// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./IFlashLoanRecipient.sol";
import "./IBalancerVault.sol";
import "./IUniswapV2Router02.sol";

contract Flashloanbot is IFlashLoanRecipient, Ownable {

    address public immutable vault;
    IUniswapV2Router02 private router;
    IERC20 borrowToken;
    IERC20 swapToken;

    event executeSuccess(uint256 amountBefore, uint256 amountAfter);

    constructor(address _vault) {
        vault = _vault;
    }

    function receiveFlashLoan(
        IERC20[] memory,
        uint256[] memory amounts,
        uint256[] memory,
        bytes memory
    ) external override {
        uint256 amount = amounts[0];
        uint256[] memory amountOuts1 = _swapTokens(address(borrowToken), address(swapToken), amount);
        uint256[] memory amountOuts2 = _swapTokens(address(swapToken), address(borrowToken), amountOuts1[0]);
        uint currentBal = borrowToken.balanceOf(address(this));

        require(currentBal >= amount, "No profit");

        borrowToken.transfer(vault, amount);
        emit executeSuccess(amount, amountOuts2[0]);
    }

    function execute(
        address _borrowToken,
        address _swapToken,
        uint256 _amount,
        address _router,
        bytes memory userData
    ) external {
        require(_amount > 0, "Invalid borrow amount");
        require(_borrowToken != address(0) && _swapToken != address(0), "Invalid token address");
        borrowToken = IERC20(_borrowToken);
        swapToken = IERC20(_swapToken);
        router = IUniswapV2Router02(_router);
        IERC20[] memory tokens;
        tokens = new IERC20[](1);
        tokens[0] = IERC20(_borrowToken);
        uint256[] memory amounts;
        amounts = new uint256[](1);
        amounts[0] = _amount;
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
            amount, 0, path, address(this), block.timestamp + 3600
        );
        return amountOuts;
    }

    function withdrawTokens(
        address[] memory _tokens
    ) public onlyOwner {
        for (uint256 i = 0; i < _tokens.length; i++) {
            address tokenAddress = _tokens[i];
            IERC20 token = IERC20(tokenAddress);
            uint256 balance = token.balanceOf(address(this));
            token.transfer(msg.sender, balance);
        }
    }
}
