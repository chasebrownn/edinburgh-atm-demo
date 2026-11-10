# EdiCoin ATM — Intro to Smart Contracts Demo

Live demo for the University of Edinburgh intro-to-smart-contracts talk.

Two tiny contracts:

- **`EdiCoin`** (`src/EdiCoin.sol`) — an ERC-20 token called EdiCoin (EDI). Anyone can `mint` tokens out of thin air and `burn` their own. A toy, on purpose.
- **`ATM`** (`src/ATM.sol`) — a cash machine loaded with EDI. Anyone can call `withdraw()` to take exactly 1 token per press, until the machine is empty.

## Demo flow

### 1. Build

```bash
forge build
```

### 2. Test

```bash
forge test -vvv
```

Tests cover mint/burn, single withdrawal, repeated withdrawals by multiple people, the out-of-cash revert, and the `Withdrawal` event.

### 3. Deploy + verify (one command)

Set up your environment (put these in `.env` and `source .env`, or export directly):

```bash
export SEPOLIA_RPC_URL=https://ethereum-sepolia-rpc.publicnode.com
export ETHERSCAN_API_KEY=<your key>   # one Etherscan v2 key works for all chains
```

Signing uses the encrypted `demo` keystore account (created with `cast wallet new ~/.foundry/keystores demo` — it prompts for a password instead of putting a raw private key on screen). Fund its address with a little Sepolia ETH from a faucet first.

Deploy to Sepolia with verification in one shot:

```bash
forge script script/Deploy.s.sol --rpc-url sepolia --account demo --broadcast --verify
```

The script deploys EdiCoin, deploys the ATM pointed at it, and loads the ATM with 1000 EDI. The addresses are printed at the end.

If verification ever fails or you want to re-run it on its own:

```bash
forge verify-contract <TOKEN_ADDRESS> src/EdiCoin.sol:EdiCoin --chain sepolia --watch
forge verify-contract <ATM_ADDRESS> src/ATM.sol:ATM --chain sepolia --watch \
  --constructor-args $(cast abi-encode "constructor(address)" <TOKEN_ADDRESS>)
```

### 4. Play with it from the terminal

```bash
export ATM=<ATM_ADDRESS>
export TOKEN=<TOKEN_ADDRESS>

# How much cash is in the machine? (returns wei, 1e18 = 1 EDI)
cast call $ATM "cashLeft()(uint256)" --rpc-url sepolia

# Press the button — withdraw 1 EDI
cast send $ATM "withdraw()" --rpc-url sepolia --account demo

# Check my balance
cast call $TOKEN "balanceOf(address)(uint256)" <MY_ADDRESS> --rpc-url sepolia

# Mint myself 50 EDI out of thin air (why toy tokens aren't money!)
cast send $TOKEN "mint(address,uint256)" <MY_ADDRESS> 50ether --rpc-url sepolia --account demo

# Burn 10 of them
cast send $TOKEN "burn(uint256)" 10ether --rpc-url sepolia --account demo
```

### 5. Let the students join in

Because the contracts are verified, students don't need any tooling:

1. Open the ATM address on [sepolia.etherscan.io](https://sepolia.etherscan.io).
2. Go to **Contract → Write Contract → Connect to Web3** (any wallet with a little Sepolia ETH — point them at a faucet beforehand, e.g. the Google Cloud or Alchemy Sepolia faucet).
3. Press **withdraw** — they just took money out of a public cash machine.
4. On **Read Contract**, watch `cashLeft` tick down live as the room drains the machine.
5. They can add the token to their wallet with the EdiCoin address to see their EDI balance.

Good discussion prompts while they play:

- What stops someone from draining the whole machine? (Nothing — and someone in the room probably will. Great segue into access control and rate limiting.)
- Anyone can `mint` — what would that mean for a real currency?
- Every withdrawal is public forever — look at the ATM's transaction list.

## Local dry run (no testnet needed)

```bash
# Terminal 1
anvil

# Terminal 2 — anvil's default funded key
export PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
forge script script/Deploy.s.sol --rpc-url http://127.0.0.1:8545 --private-key $PRIVATE_KEY --broadcast
```

Then use the same `cast` commands with `--rpc-url http://127.0.0.1:8545`.
