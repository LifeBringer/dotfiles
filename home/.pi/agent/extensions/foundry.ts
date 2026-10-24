/**
 * Route pi's built-in `anthropic` and `openai` providers to the Microsoft
 * Foundry resources that also serve Claude Code and Codex on this machine.
 *
 * Why an extension and not models.json: pi resolves `$VAR` in `apiKey` and
 * `headers` but not in `baseUrl`, and this repo is public, so the Foundry
 * hostname has to come from the environment at runtime. Anthropic uses
 * ANTHROPIC_FOUNDRY_RESOURCE and ANTHROPIC_FOUNDRY_API_KEY. OpenAI uses
 * AZURE_OPENAI_FOUNDRY_RESOURCE and AZURE_OPENAI_API_KEY, falling back to the
 * Anthropic resource when no separate OpenAI resource is configured.
 *
 * Why override the built-in ids instead of adding a "foundry" provider: pi
 * keys some behaviour on `model.provider === "anthropic"` (tool references,
 * subscription warnings), and `anthropic/claude-opus-5` is the name everyone
 * expects. OpenAI overrides only connection settings so Pi owns its catalog.
 * Anthropic keeps its deployment filter and catalog-derived metadata because
 * Foundry requires the compatibility adjustment below.
 *
 * Foundry gotcha: it has no Anthropic server-side fallback, and pi's catalog
 * entries for Opus 5 and Fable carry `allowedFallbackModels`, which makes pi
 * send a `fallbacks` param. It is stripped below.
 */
import type { Api, Model } from "@earendil-works/pi-ai";
import { getModel } from "@earendil-works/pi-ai";
import type { ExtensionAPI, ProviderModelConfig } from "@earendil-works/pi-coding-agent";

// Anthropic deployments use Pi's metadata with Foundry's fallback adjustment.
const ANTHROPIC_DEPLOYMENTS = ["claude-fable-5-1", "claude-opus-5-5", "claude-opus-5", "claude-sonnet-5-5", "claude-sonnet-5", "claude-opus-4-8", "claude-haiku-4-5"];

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
	if (anthropicResource) {
		const models = ANTHROPIC_DEPLOYMENTS.flatMap((id) => {
			const base = lookup("anthropic", id);
			if (!base) unknown.push(`anthropic/${id}`);
			return base ? [define(base)] : [];
		});
		pi.registerProvider("anthropic", {
			name: "Claude (Microsoft Foundry)",
			baseUrl: `https://${hostname(anthropicResource)}/anthropic`,
			apiKey: "$ANTHROPIC_FOUNDRY_API_KEY",
			api: "anthropic-messages",
			models,
		});
	}
	if (openaiResource) {
		const apiKey = azureResource ? "$AZURE_OPENAI_API_KEY" : "$ANTHROPIC_FOUNDRY_API_KEY";
		pi.registerProvider("openai", {
			name: "OpenAI (Microsoft Foundry)",
			baseUrl: `https://${hostname(openaiResource)}/openai/v1`,
			apiKey,
			headers: { "api-key": apiKey },
		});
	}
	// pi's stock Azure provider lights up because AZURE_OPENAI_API_KEY (Codex's
	// key for the other resource) is set, but it has no base URL here and every
	// request would fail. An empty model list keeps it out of /model.
	pi.registerProvider("azure-openai-responses", { models: [] });

	if (unknown.length > 0) {
		pi.on("session_start", async (_event, ctx) => {
			ctx.ui.notify(`foundry: not in pi's model catalog, skipped: ${unknown.join(", ")}`, "warning");
		});
	}
}
