/**
 * Route pi's built-in `anthropic`, `openai` and `xai` providers to the
 * Microsoft Foundry resources that also serve Claude Code and Codex on this
 * machine.
 *
 * Why an extension and not models.json: pi resolves `$VAR` in `apiKey` and
 * `headers` but not in `baseUrl`, and this repo is public, so the Foundry
 * hostname has to come from the environment at runtime. Anthropic and xAI use
 * ANTHROPIC_FOUNDRY_RESOURCE and ANTHROPIC_FOUNDRY_API_KEY. OpenAI uses
 * AZURE_OPENAI_FOUNDRY_RESOURCE and AZURE_OPENAI_API_KEY, falling back to the
 * Anthropic resource when no separate OpenAI resource is configured.
 *
 * Why override the built-in ids instead of adding a "foundry" provider: pi
 * keys some behaviour on `model.provider === "anthropic"` (tool references,
 * subscription warnings), and `anthropic/claude-opus-5` is the name everyone
 * expects.
 *
 * Why list deployments: without a list, /model offers pi's whole catalog for
 * each provider, and most of those models are not deployed on Foundry and
 * fail at request time. The lists only name deployments; metadata still comes
 * from pi's catalog. Check them against `bin/foundry-models` in this repo when
 * Foundry changes.
 *
 * Foundry gotcha: it has no Anthropic server-side fallback, and pi's catalog
 * entries for Opus 5 and Fable carry `allowedFallbackModels`, which makes pi
 * send a `fallbacks` param. It is stripped below.
 */
import type { Api, Model } from "@earendil-works/pi-ai";
import { getModel } from "@earendil-works/pi-ai";
import type { ExtensionAPI, ProviderModelConfig } from "@earendil-works/pi-coding-agent";

// Deployments on the Anthropic resource. claude-mythos-5-1 is deployed too,
// but it accepts only Entra ID auth and rejects the API key used here.
const ANTHROPIC_DEPLOYMENTS = ["claude-fable-5-1", "claude-opus-5-5", "claude-opus-5", "claude-sonnet-5-5", "claude-sonnet-5", "claude-haiku-4-5"];

// Deployments on the OpenAI resource (AZURE_OPENAI_FOUNDRY_RESOURCE).
const OPENAI_DEPLOYMENTS = ["gpt-6.1-sol", "gpt-6-sol", "gpt-6-astra", "gpt-6-luna", "gpt-5.6-sol", "gpt-5.6-terra", "gpt-5.6-luna", "gpt-5.5"];

// Grok deployments. They live on the Anthropic resource, not the OpenAI one,
// and use the same OpenAI-style /openai/v1 endpoint with ANTHROPIC_FOUNDRY_API_KEY.
const XAI_DEPLOYMENTS = ["grok-4.7"];

// getModel is typed against the static catalog; loosen it so unknown ids
// return undefined instead of failing to type-check.
const lookup = getModel as unknown as (provider: string, id: string) => Model<Api> | undefined;

function define(base: Model<Api>): ProviderModelConfig {
	// Foundry rejects server-side fallback, so never forward allowedFallbackModels.
	const { allowedFallbackModels: _unsupported, ...compat } = (base.compat ?? {}) as Record<string, unknown>;
	// A model-level URL would win over the provider's Foundry endpoint.
	const { baseUrl: _endpoint, ...model } = base;
	return {
		...model,
		compat: compat as ProviderModelConfig["compat"],
	};
}

export default function (pi: ExtensionAPI) {
	const anthropicResource = process.env.ANTHROPIC_FOUNDRY_RESOURCE;
	const azureResource = process.env.AZURE_OPENAI_FOUNDRY_RESOURCE;
	const openaiResource = azureResource || anthropicResource;
	if (!anthropicResource && !openaiResource) return;
	// Claude Code wants the bare resource name; accept a full hostname too.
	const hostname = (resource: string) => resource.includes(".") ? resource : `${resource}.services.ai.azure.com`;

	const unknown: string[] = [];
	const deployed = (provider: string, ids: string[]) =>
		ids.flatMap((id) => {
			const base = lookup(provider, id);
			if (!base) unknown.push(`${provider}/${id}`);
			return base ? [define(base)] : [];
		});
	if (anthropicResource) {
		pi.registerProvider("anthropic", {
			name: "Claude (Microsoft Foundry)",
			baseUrl: `https://${hostname(anthropicResource)}/anthropic`,
			apiKey: "$ANTHROPIC_FOUNDRY_API_KEY",
			api: "anthropic-messages",
			models: deployed("anthropic", ANTHROPIC_DEPLOYMENTS),
		});
		pi.registerProvider("xai", {
			name: "xAI (Microsoft Foundry)",
			baseUrl: `https://${hostname(anthropicResource)}/openai/v1`,
			apiKey: "$ANTHROPIC_FOUNDRY_API_KEY",
			headers: { "api-key": "$ANTHROPIC_FOUNDRY_API_KEY" },
			models: deployed("xai", XAI_DEPLOYMENTS),
		});
	}
	if (openaiResource) {
		const apiKey = azureResource ? "$AZURE_OPENAI_API_KEY" : "$ANTHROPIC_FOUNDRY_API_KEY";
		pi.registerProvider("openai", {
			name: "OpenAI (Microsoft Foundry)",
			baseUrl: `https://${hostname(openaiResource)}/openai/v1`,
			apiKey,
			headers: { "api-key": apiKey },
			models: deployed("openai", OPENAI_DEPLOYMENTS),
		});
	}
	// pi's stock Azure provider lights up because AZURE_OPENAI_API_KEY (Codex's
	// key for the other resource) is set, but it has no base URL here and every
	// request would fail. An empty model list keeps it out of /model.
	pi.registerProvider("azure", { models: [] });

	if (unknown.length > 0) {
		pi.on("session_start", async (_event, ctx) => {
			ctx.ui.notify(`foundry: not in pi's model catalog, skipped: ${unknown.join(", ")}`, "warning");
		});
	}
}
