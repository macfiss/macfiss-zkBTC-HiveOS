#!/usr/bin/env bash
# This code is included in /hive/bin/custom function

[[ -z $CUSTOM_TEMPLATE ]] && echo -e "${YELLOW}CUSTOM_TEMPLATE is empty${NOCOLOR}" && return 1
[[ -z $CUSTOM_URL ]] && echo -e "${YELLOW}CUSTOM_URL is empty${NOCOLOR}" && return 1

# make JSON
conf=$(jq -n \
  --arg isLogFile false \
  --arg minerJsonAPI "http://127.0.0.1:4078" \
  --arg minerCcminerAPI "127.0.0.1:4068" \
  --arg web3api "https://mainnet.era.zksync.io" \
  --arg contractAddress "0x366d17aDB24A7654DbE82e79F85F9Cb03c03cD0D" \
  --arg abiFile "zkBTC.abi" \
  --arg overrideMaxTarget "0x0" \
  --arg customDifficulty 0 \
  --arg submitStale false \
  --arg maxScanRetry 3 \
  --arg pauseOnFailedScans 3 \
  --arg networkUpdateInterval 50000 \
  --arg hashrateUpdateInterval 60000 \
  --arg kingAddress "" \
  --arg minerAddress "${CUSTOM_WALLET_ADDRESS}" \
  --arg primaryPool "${CUSTOM_PRIMARY_POOL_URL}" \
  --arg secondaryPool "" \
  --arg MaxZKBTCperMint 500.0 \
  --arg MinZKBTCperMint 250.0 \
  --arg HowManyBlocksAWAYFromAdjustmentToSendMinimumZKBTC 200.0 \
  --arg privateKey "${CUSTOM_WALLET_PRIVATE_KEY}" \
  --arg gasToMine 3.2 \
  --arg gasLimit 551704624 \
  --arg gasApiURL "" \
  --arg gasApiPath "$.result.SafeGasPrice" \
  --arg gasApiMultiplier 1.0 \
  --arg gasApiOffset 0.1 \
  --arg gasApiMax 0.5 \
  --arg allowCPU false \
  --arg cpuMode false \
  --argjson cpuDevices [] \
  --arg allowIntel true \
  --argjson intelDevices [] \
  --arg allowAMD true \
  --argjson amdDevices [] \
  --arg allowCUDA true \
  --argjson cudaDevices [] \
'{$isLogFile, $minerJsonAPI, $minerCcminerAPI, $web3api, $contractAddress, $abiFile, $overrideMaxTarget, $customDifficulty, $submitStale, $maxScanRetry, $pauseOnFailedScans, $networkUpdateInterval, $hashrateUpdateInterval, $kingAddress, $minerAddress, $primaryPool, $secondaryPool, $MaxZKBTCperMint, $MinZKBTCperMint, $HowManyBlocksAWAYFromAdjustmentToSendMinimumZKBTC, $privateKey, $gasToMine, $gasLimit, $gasApiURL, $gasApiPath, $gasApiMultiplier, $gasApiOffset, $gasApiMax, $allowCPU, $cpuMode, $cpuDevices, $allowIntel, $intelDevices, $allowAMD, $amdDevices, $allowCUDA, $cudaDevices}')

#replace tpl values in whole file
[[ -z $EWAL && -z $ZWAL && -z $DWAL ]] && echo -e "${RED}No WAL address is set${NOCOLOR}"
[[ ! -z $EWAL ]] && conf=$(sed "s/%EWAL%/$EWAL/g" <<< "$conf") #|| echo "${RED}EWAL not set${NOCOLOR}"
[[ ! -z $DWAL ]] && conf=$(sed "s/%DWAL%/$DWAL/g" <<< "$conf") #|| echo "${RED}DWAL not set${NOCOLOR}"
[[ ! -z $ZWAL ]] && conf=$(sed "s/%ZWAL%/$ZWAL/g" <<< "$conf") #|| echo "${RED}ZWAL not set${NOCOLOR}"
[[ ! -z $EMAIL ]] && conf=$(sed "s/%EMAIL%/$EMAIL/g" <<< "$conf")
[[ ! -z $WORKER_NAME ]] && conf=$(sed "s/%WORKER_NAME%/$WORKER_NAME/g" <<< "$conf") #|| echo "${RED}WORKER_NAME not set${NOCOLOR}"

[[ -z $CUSTOM_CONFIG_FILENAME ]] && echo -e "${RED}No CUSTOM_CONFIG_FILENAME is set${NOCOLOR}" && return 1
echo "$conf" > $CUSTOM_CONFIG_FILENAME
echo "$CUSTOM_USER_CONFIG" > ${CUSTOM_CONFIG_FILENAME}.param
