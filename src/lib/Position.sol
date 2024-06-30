// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.14;

import "prb-math/PRBMath.sol";

import "./FixedPoint128.sol";
import "./LiquidityMath.sol";

library Position {
    struct Info {
        uint128 liquidity;
        uint128 feeGrowthInside0LastX128;
        uint128 feeGrowthInside1LastX128;
        uint64 tokensOwed0;
        uint64 tokensOwed1;
    }

    function get(
        mapping(bytes32 => Info) storage self,
        address owner,
        int24 lowerTick,
        int24 upperTick
    ) internal view returns (Position.Info storage position) {
        position = self[
            keccak256(abi.encodePacked(owner, lowerTick, upperTick))
        ];
    }

    function update(
        Info storage self,
        int128 liquidityDelta,
        uint128 feeGrowthInside0X128,
        uint128 feeGrowthInside1X128
    ) internal {
        uint256 tokensOwed0 = uint128(
            PRBMath.mulDiv(
                feeGrowthInside0X128 - self.feeGrowthInside0LastX128,
                self.liquidity,
                FixedPoint128.Q128
            )
        );
       
