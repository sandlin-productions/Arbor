//
//  MathUtils.swift
//  Arbor
//
//  Created by Stephen Sandlin on 1/11/25.
//

import simd

func rotationMatrix(angle: Float, axis: SIMD3<Float>) -> float4x4 {
    let normalizedAxis = normalize(axis)
    let cosAngle = cos(angle)
    let sinAngle = sin(angle)
    let oneMinusCos = 1.0 - cosAngle

    let x = normalizedAxis.x
    let y = normalizedAxis.y
    let z = normalizedAxis.z

    return float4x4(
        SIMD4<Float>(cosAngle + x * x * oneMinusCos, y * x * oneMinusCos + z * sinAngle, z * x * oneMinusCos - y * sinAngle, 0.0),
        SIMD4<Float>(x * y * oneMinusCos - z * sinAngle, cosAngle + y * y * oneMinusCos, z * y * oneMinusCos + x * sinAngle, 0.0),
        SIMD4<Float>(x * z * oneMinusCos + y * sinAngle, y * z * oneMinusCos - x * sinAngle, cosAngle + z * z * oneMinusCos, 0.0),
        SIMD4<Float>(0.0, 0.0, 0.0, 1.0)
    )
}
