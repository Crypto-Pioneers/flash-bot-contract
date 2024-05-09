// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IFlashLoanRecipient.sol";
import "./IBalancerVault.sol";
import "hardhat/console.sol";
import "./IUniswapV2Router02.sol";

contract Flasloanbot is IFlashLoanRecipient, Ownable {
    using SafeMath for uint256;

    address public immutable vault;
    IUniswapV2Router02 private router;
    IERC20 private weth;

    constructor(address _vault) {
        vault = _vault;
    }

    function receiveFlashLoan(
        IERC20[] memory tokens,
        uint256[] memory amounts,
        uint256[] memory feeAmounts,
        bytes memory
    ) external override {
        IERC20 token = tokens[0];
        uint256 amount = amounts[0];
        console.log("borrowed amount:", amount);
        uint256 feeAmount = feeAmounts[0];
        console.log("flashloan fee: ", feeAmount);
        uint256[] memory amountOuts1 = _swapTokens(address(tokens[0]), address(tokens[1]), amount);
        _swapTokens(address(tokens[1]), address(tokens[0]), amountOuts1[0]);
        uint currentBal = token.balanceOf(address(this));
        if (currentBal < amount) {
            token.transferFrom(msg.sender, address(this), (amount - currentBal));
        }
        
        token.transfer(vault, amount);
    }

    function execute(
        IERC20[] memory _tokens,
        uint256[] memory _amounts,
        address _router,
        address _weth,
        bytes memory userData
    ) external {
        require(_tokens.length == 2, "Invalid number of tokens");
        router = IUniswapV2Router02(_router);
        weth = IERC20(_weth);
        IERC20[] memory tokens;
        tokens[0] = _tokens[0];
        uint256[] memory amounts;
        amounts[0] = _amounts[0];
        IBalancerVault(vault).flashLoan(
            IFlashLoanRecipient(address(this)),
            tokens,
            amounts,
            userData
        );
    }

    function _swapTokens(
        address tokenA,
        address tokenB,
        uint256 amount
    ) internal returns (uint256[] memory){
        IERC20(tokenA).approve(address(router), amount);
        address[] memory path;
        path = new address[](2);
        path[0] = tokenA;
        path[1] = tokenB;
        uint256[] memory amountOuts = router.swapExactTokensForTokens(
            amount, 0, path, address(this), block.timestamp
        );
        return amountOuts;
    }

    function withdraw(address _tokenAddr) external onlyOwner {
        IERC20 token = IERC20(_tokenAddr);
        uint256 balance = token.balanceOf(address(this));
        if (balance > 0) {
            token.approve(msg.sender, balance);
            token.transfer(msg.sender, balance);
        }
    }
}
