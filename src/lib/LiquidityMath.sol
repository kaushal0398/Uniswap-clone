// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.14;

import "prb-math/PRBMath.sol";
import "./FixedPoint96.sol";

library LiquidityMath {
    /// $L = \frac{\Delta x \sqrt{P_u} \sqrt{P_l}}{\Delta \sqrt{P}}$
    function getLiquidityForAmount0(
        uint160 sqrtPriceAX96,
        uint160 sqrtPriceBX96,
        uint256 amount0
    ) internal pure returns (uint128 liquidity) {
        if (sqrtPriceAX96 > sqrtPriceBX96)
            (sqrtPriceAX96, sqrtPriceBX96) = (sqrtPriceBX96, sqrtPriceAX96);

        uint256 intermediate = PRBMath.mulDiv(
            sqrtPriceAX96,
            sqrtPriceBX96,
            FixedPoint96.Q96
        );
        liquidity = uint128(
            PRBMath.mulDiv(amount0, intermediate, sqrtPriceBX96 - sqrtPriceAX96)
        );
    }

    /// $L = \frac{\Delta y}{\Delta \sqrt{P}}$
    function getLiquidityForAmount1(
        uint160 sqrtPriceAX96,
        uint160 sqrtPriceBX96,
        uint256 amount1
    ) internal pure returns (uint128 liquidity) {
        if (sqrtPriceAX96 > sqrtPriceBX96)
            (sqrtPriceAX96, sqrtPriceBX96) = (sqrtPriceBX96, sqrtPriceAX96);

        liquidity = uint128(
            PRBMath.mulDiv(
                amount1,
                FixedPoint96.Q96,
                sqrtPriceBX96 - sqrtPriceAX96
            )
        );
    }

   
