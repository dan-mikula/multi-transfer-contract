from brownie import accounts, config, MultiTransfer, USDT


def deploy_token():
    print("Deploying ERC20 Contract")
    account = accounts.add(config["wallets"]["from_key_presenter_1"])
    USDT.deploy({"from": account}, publish_source=False)


def deploy_multitransfer_contract():
    print("Deploying MultiTransfer Contract")
    account = accounts.add(config["wallets"]["from_key_presenter_1"])
    MultiTransfer.deploy({"from": account}, publish_source=False)


def main():
    deploy_token()
    deploy_multitransfer_contract()
