from typing import List
from brownie import MultiTransfer, USDT, accounts, config


def transfer_tokens_from_wallet(addresses: List, amounts: List) -> None:
    """
    addresses: List - Takes in a list of addrdesses.
                    example: ["0x123456", "0x123456"]

    amounts: List - Takes in a list of amounts
                    example: [100*10**18, 100*10**18]
    """
    account = accounts.add(config["wallets"]["from_key_presenter_1"])
    multitransfer = MultiTransfer[-1]
    token = USDT[-1]

    # calculate the amount to approve
    total = 0
    for x in amounts:
        total = total + x
    token.approve(multitransfer.address, total, {"from": account, "gas_limit": 50000})
    tx = multitransfer.multiTransfer(
        addresses, amounts, token, {"from": account, "gas_limit": 200000}
    )
    tx.wait(1)


def transfer_tokens_from_contract(addresses: List, amounts: List):
    """
    addresses: List - Takes in a list of addrdesses.
                    example: ["0x123456", "0x123456"]

    amounts: List - Takes in a list of amounts
                    example: [100*10**18, 100*10**18]
    """
    account = accounts.add(config["wallets"]["from_key_presenter_1"])
    multitransfer = MultiTransfer[-1]
    token = USDT[-1]

    tx = multitransfer.multiTransfer(
        addresses, amounts, token, {"from": account, "gas_limit": 200000}
    )
    tx.wait(1)


def set_protocol_state(state: bool) -> None:
    account = accounts.add(config["wallets"]["from_key_presenter_1"])
    multitransfer = MultiTransfer[-1]
    multitransfer.setProtocolState(state, {"from": account})


def set_fee_amount(fee_percent: int) -> None:
    """
    fee_percent: int - Takes in an integer
                    example: 3 = 0.3%
    """
    account = accounts.add(config["wallets"]["from_key_presenter_1"])
    multitransfer = MultiTransfer[-1]
    multitransfer.setFeeAmount(fee_percent, {"from": account})


def main():
    set_fee_amount(3)
    set_protocol_state(True)
    transfer_tokens_from_contract(
        addresses=["0x123456", "0x123456"], amounts=[100 * 10 ** 18, 120 * 10 ** 18]
    )
    transfer_tokens_from_wallet(
        addresses=["0x123456", "0x123456"], amounts=[100 * 10 ** 18, 120 * 10 ** 18]
    )
