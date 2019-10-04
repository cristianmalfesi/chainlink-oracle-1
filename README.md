# chainlink-Oracle

Implementation of a [Chainlink requesting contract](https://docs.chain.link/docs/create-a-chainlinked-project).


## Installation


```bash
npm install
```

## Deploy to Kovan

Create `.env` file with:
```
RPC_URL=https://kovan.infura.io/v3/INFURA_ID
PK=
ORACLE=0x2f90A6D021db21e1B2A077c5a37B3C7E75D15b7e
JOB_ID=29fa9aa13bf1468788b7cc4a500a45b8
```
Oracle and job id were taken from https://docs.chain.link/docs/testnet-oracles

Deploy contract
```bash
npm run migrate:kovan
```

Fund your contract with TOKEN link using the faucet: https://kovan.chain.link
