#!/bin/bash

FUNCTION_APP_NAME="my-cron-function"
RESOURCE_GROUP="terraform-vm-group"
WEBCRAWLER_DIR="./webcrawler"
ZIP_FILE="./webcrawler.zip"


echo "running npm install $WEBCRAWLER_DIR..."
cd "$WEBCRAWLER_DIR" || exit 1
npm install
cd - > /dev/null


echo "zipping $WEBCRAWLER_DIR..."
zip -r "$ZIP_FILE" "$WEBCRAWLER_DIR"/*

echo "deploying $ZIP_FILE to Az crone job $FUNCTION_APP_NAME..."
az functionapp deployment source config-zip \
    --name "$FUNCTION_APP_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --src "$ZIP_FILE"


echo "Listing functions in $FUNCTION_APP_NAME:"
az functionapp function list \
    --name "$FUNCTION_APP_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --output table


echo "removing zip again"
rm "$ZIP_FILE"

echo "finished"
