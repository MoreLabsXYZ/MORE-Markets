# MORE-Markets

This repository contains the smart contracts source code and markets configuration for More Markets. It is base on the fork of Aave V3. The repository uses Docker Compose and Hardhat as development environment for compilation, testing and deployment tasks.

## What is MORE Markets?

MORE Markets is a decentralized non-custodial liquidity markets protocol where users can participate as suppliers or borrowers. Suppliers provide liquidity to the market to earn a passive income, while borrowers are able to borrow in an overcollateralized (perpetually) or undercollateralized (one-block liquidity) fashion.

## Audits and Formal Verification

You can find all audit reports under the audits folder

### Ordered by Aave

V3.0.1 - December 2022

- [PeckShield](./audits/Aave/09-12-2022_PeckShield_AaveV3-0-1.pdf)
- [SigmaPrime](./audits/Aave/23-12-2022_SigmaPrime_AaveV3-0-1.pdf)

V3 Round 1 - October 2021

- [ABDK](./audits/Aave/27-01-2022_ABDK_AaveV3.pdf)
- [OpenZeppelin](./audits/Aave/01-11-2021_OpenZeppelin_AaveV3.pdf)
- [Trail of Bits](./audits/Aave/07-01-2022_TrailOfBits_AaveV3.pdf)
- [Peckshield](./audits/Aave/14-01-2022_PeckShield_AaveV3.pdf)

V3 Round 2 - December 2021

- [SigmaPrime](./audits/Aave/27-01-2022_SigmaPrime_AaveV3.pdf)

Formal Verification - November 2021-January 2022

- [Certora](./certora/Aave_V3_Formal_Verification_Report_Jan2022.pdf)

### Ordered by MORE

V3.0.2 - December 2024

- [PeckShield](./audits/MORE/PeckShield-Audit-Report-MOREMarkets-v1.0.pdf)

## Getting Started

You can install `@more-labs/more-markets` as an NPM package in your Hardhat or Truffle project to import the contracts and interfaces:

`npm install @more-labs/more-markets`

Import at Solidity files:

```
import {IPool} from "@more-labs/more-markets/contracts/interfaces/IPool.sol";

contract Misc {

  function supply(address pool, address token, address user, uint256 amount) public {
    IPool(pool).supply(token, amount, user, 0);
    {...}
  }
}
```

The JSON artifacts with the ABI and Bytecode are also included in the bundled NPM package at `artifacts/` directory.

Import JSON file via Node JS `require`:

```
const PoolV3Artifact = require('@more-labs/more-markets/artifacts/contracts/protocol/pool/Pool.sol/Pool.json');

// Log the ABI into console
console.log(PoolV3Artifact.abi)
```

## Setup

The repository uses Docker Compose to manage sensitive keys and load the configuration. Prior to any action like test or deploy, you must run `docker-compose up` to start the `contracts-env` container, and then connect to the container console via `docker-compose exec contracts-env bash`.

Follow the next steps to setup the repository:

- Install `docker` and `docker-compose`
- Create an environment file named `.env` and fill the next environment variables

```
# Add Alchemy or Infura provider keys, alchemy takes preference at the config level
ALCHEMY_KEY=""
INFURA_KEY=""


# Optional, if you plan to use Tenderly scripts
TENDERLY_PROJECT=""
TENDERLY_USERNAME=""

```

## Test

You can run the full test suite with the following commands:

```
# In one terminal
docker-compose up

# Open another tab or terminal
docker-compose exec contracts-env bash

# A new Bash terminal is prompted, connected to the container
npm run test
```
