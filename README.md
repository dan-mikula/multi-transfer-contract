# ERC20 Multi Transfer Demo
Disclaimer: Do not use in production. <br />
Transfers tokens to multiple addresses from a wallet or from the contract itself.
## Installation
Project is made with Brownie.
```
pip install eth-brownie
```
Rename `.env-example` to `.env`.
```
mv .env-example .env
```
Edit the `.env` file and add your keys.

## Usage
```
To deploy the main wallet, please use `00_deploy.py`
```
brownie run scripts/00_deploy.py --network <insert network>
```
Please edit deployment scripts to your need.

## TODO
- Do tests