#!/usr/bin/env bash
set -u  # Fail on unset variables, but don’t exit on errors in the loop

CACHE_FILE="/workspaces/terraform_whoKnows/01_vm/.azure_valid_regions.json"
TEMP_RG="policy-test-rg"

log() {
    echo -e "$@" >&2
}

# Use cache if available
if [ -f "$CACHE_FILE" ]; then
    log "Using cached valid regions from $CACHE_FILE"
    cat "$CACHE_FILE"
    exit 0
fi

log "-----------------------------------------"
log " Starting Azure region availability check"
log "-----------------------------------------"

# Create temporary resource group (suppress errors if exists)
log "Creating temporary resource group: $TEMP_RG"
az group create --name "$TEMP_RG" --location "uksouth" --output none >/dev/null 2>&1 || true

valid_regions=()

regions=$(az account list-locations --query "[].name" -o tsv)

log ""
log "Checking region availability..."
log ""

for region in $regions; do
    region="${region%$'\r'}"
    storage_name="test$(date +%s)$RANDOM"

    log " • Testing region: $region"

    if az storage account create \
            --name "${storage_name}" \
            --resource-group "$TEMP_RG" \
            --location "$region" \
            --sku Standard_LRS \
            --output none >/dev/null 2>&1; then

        log "   Region allowed: $region"
        valid_regions+=("$region")

        # Delete the storage account safely
        az storage account delete \
          --name "${storage_name}" \
          --resource-group "$TEMP_RG" \
          --yes >/dev/null 2>&1 || true
    else
        log "   Region blocked: $region"
    fi

    log ""
done

log "Cleaning up temporary resource group..."
az group delete --name "$TEMP_RG" --yes --no-wait >/dev/null 2>&1 || true

# Convert array to comma-separated string
output=$(IFS=, ; echo "${valid_regions[*]}")

# Save JSON to cache file
printf '{"regions": "%s"}\n' "$output" > "$CACHE_FILE"

# Print JSON to stdout for Terraform
cat "$CACHE_FILE"

log "Region testing completed! Valid regions saved to $CACHE_FILE"
