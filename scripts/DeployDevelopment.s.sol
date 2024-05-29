// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.14;

import "forge-std/console.sol";
import "forge-std/Script.sol";

import "../src/interfaces/IUniswapV3Manager.sol";
import "../src/lib/FixedPoint96.sol";
import "../src/lib/Math.sol";
import "../src/UniswapV3Factory.sol";
import "../src/UniswapV3Manager.sol";
import "../src/UniswapV3Pool.sol";
import "../src/UniswapV3Quoter.sol";
import "../test/ERC20Mintable.sol";
import "../test/TestUtils.sol";

contract DeployDevelopment is Script, TestUtils {
    struct TokenBalances {
        uint256 uni;
        uint256 usdc;
        uint256 usdt;
        uint256 wbtc;
        uint256 weth;
    }

    TokenBalances balances =
        TokenBalances({
            uni: 200 ether,
            usdc: 2_000_000 ether,
            usdt: 2_000_000 ether,
            wbtc: 20 ether,
            weth: 100 ether
        });

    function run() public {
        // DEPLOYING STARGED
        vm.startBroadcast();

        ERC20Mintable weth = new ERC20Mintable("Wrapped Ether", "WETH", 18);
        ERC20Mintable usdc = new ERC20Mintable("USD Coin", "USDC", 18);
        ERC20Mintable uni = new ERC20Mintable("Uniswap Coin", "UNI", 18);
        ERC20Mintable wbtc = new ERC20Mintable("Wrapped Bitcoin", "WBTC", 18);
        ERC20Mintable usdt = new ERC20Mintable("USD Token", "USDT", 18);

        UniswapV3Factory factory = new UniswapV3Factory();
        UniswapV3Manager manager = new UniswapV3Manager(address(factory));
        UniswapV3Quoter quoter = new UniswapV3Quoter(address(factory));

        UniswapV3Pool wethUsdc = deployPool(
            factory,
            address(weth),
            address(usdc),
            3000,
            5000
        );

        UniswapV3Pool wethUni = deployPool(
            factory,
            address(weth),
            address(uni),
            3000,
            10
        );

        UniswapV3Pool wbtcUSDT = deployPool(
            factory,
            address(wbtc),
            address(usdt),
            3000,
            20_000
        );

        UniswapV3Pool usdtUSDC = deployPool(
            factory,
            address(usdt),
            address(usdc),
            500,
            1
        );

        function testCalcAmount0DeltaNegative() public {
        int256 amount0 = Math.calcAmount0Delta(
            TickMath.getSqrtRatioAtTick(85176),
            TickMath.getSqrtRatioAtTick(86129),
            int128(-1517882343751509868544)
        );

        assertEq(amount0, -0.998833192822975408 ether);
    }

    function testCalcAmount1DeltaNegative() public {
        int256 amount1 = Math.calcAmount1Delta(
            TickMath.getSqrtRatioAtTick(84222),
            TickMath.getSqrtRatioAtTick(85176),
            int128(-1517882343751509868544)
        );

        assertEq(amount1, -4999.187247111820044640 ether);
    }
}

