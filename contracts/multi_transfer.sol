// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../interfaces/IERC20.sol";

contract MultiTransfer is Ownable {
    address public FEE_ADDRESS;
    uint256 public FEE_AMOUNT;

    enum PROTOCOL_STATE {
        OPEN,
        CLOSED
    }

    PROTOCOL_STATE public protocol_state;

    event moneySent(address _from, uint256 _total, uint256 _fees);

    constructor() {
        FEE_ADDRESS = msg.sender;
        FEE_AMOUNT = 0.1 ether;
        protocol_state = PROTOCOL_STATE.CLOSED;
    }

    function setFeeAddress(address _address) external onlyOwner {
        FEE_ADDRESS = _address;
    }

    function setFeeAmount(uint256 _amount) external onlyOwner {
        FEE_AMOUNT = _amount;
    }

    function getFeeAmount() external view returns (uint256) {
        return FEE_AMOUNT;
    }

    function setProtocolState(bool _state) external onlyOwner {
        if (_state == true) {
            protocol_state = PROTOCOL_STATE.OPEN;
        } else if (_state == false) {
            protocol_state = PROTOCOL_STATE.CLOSED;
        }
    }

    function retrieveProtocolState() external view returns (bool) {
        if (protocol_state == PROTOCOL_STATE.OPEN) return true;
        if (protocol_state == PROTOCOL_STATE.CLOSED) return false;
    }

    function calculateFee(uint256 _amount)
        public
        view
        returns (uint256, uint256)
    {
        uint256 amount = _amount - FEE_AMOUNT;
        return (FEE_AMOUNT, amount);
    }

    function multiTransfer(
        address[] calldata _addresses,
        uint256[] calldata _amounts,
        address _tokenAddress
    ) external {
        require(protocol_state == PROTOCOL_STATE.OPEN, "Protocol is closed.");
        require(
            _addresses.length == _amounts.length,
            "Addresses and Amounts length does not match."
        );
        require(_addresses.length > 0, "No addresses sent.");
        require(_amounts.length > 0, "No amounts sent.");
        uint256 fees = 0;
        uint256 total = 0;
        for (uint256 i = 0; i < _addresses.length; i++) {
            (uint256 fee, uint256 amount) = calculateFee(_amounts[i]);
            fees = fees + fee;
            total = total + amount;
            IERC20(_tokenAddress).transferFrom(
                msg.sender,
                _addresses[i],
                amount
            );
        }
        IERC20(_tokenAddress).transferFrom(msg.sender, FEE_ADDRESS, fees);
        emit moneySent(msg.sender, total, fees);
    }

    function multiTransferFromContract(
        address[] calldata _addresses,
        uint256[] calldata _amounts,
        address _tokenAddress
    ) external {
        require(protocol_state == PROTOCOL_STATE.OPEN, "Protocol is closed");
        require(
            _addresses.length == _amounts.length,
            "Addresses and amounts length does not match"
        );
        require(_addresses.length > 0, "No addresses sent");
        require(_amounts.length > 0, "No amounts sent");
        uint256 fees = 0;
        uint256 total = 0;
        for (uint256 i = 0; i < _addresses.length; i++) {
            (uint256 fee, uint256 amount) = calculateFee(_amounts[i]);
            fees = fees + fee;
            total = total + amount;
            IERC20(_tokenAddress).transfer(_addresses[i], amount);
        }
        emit moneySent(address(this), total, fees);
    }
}
