mod ZKFloat;
fn main(
    x : [Field; 18],
    y : [Field; 18],
    inp : pub [Field; 3],
    op: pub [Field;3]
){
    let sum_x = count_sum(x);
    let sum_y = count_sum(y);
    let sum_xy = mul_sum(x,y);
    let sum_xx = mul_sum(x,x);
    let a = calc_a(sum_x, sum_y, sum_xx, sum_xy);
    let b = calc_b(sum_x, sum_y, sum_xx, sum_xy);
    let inp_float = ZKFloat::Float{sign: inp[0], mantissa: inp[1], exponent: inp[2]};
    let mut mid_float = ZKFloat::mulFloats(inp_float, b);
    mid_float = ZKFloat::addFloats(mid_float, a);
    assert(op[2] == mid_float.exponent);
    assert(op[0] == mid_float.sign);
    assert((mid_float.mantissa as u64 <= op[1] as u64+100000) | (mid_float.mantissa as u64 >= op[1] as u64-100000));
}

fn calc_a(sum_x: ZKFloat::Float, sum_y: ZKFloat::Float, sum_xx: ZKFloat::Float, sum_xy: ZKFloat::Float) -> ZKFloat::Float{
    let mid_float1 = ZKFloat::mulFloats(sum_y, sum_xx);
    let mid_float2 = ZKFloat::mulFloats(sum_x, sum_xy);
    let mid_float3 = ZKFloat::mulFloats(ZKFloat::Float{sign:0, mantissa:6, exponent:100}, sum_xx);
    let mid_float4 = ZKFloat::mulFloats(sum_x, sum_x);
    let mid_float5 = ZKFloat::subFloats(mid_float1, mid_float2);
    let mid_float6 = ZKFloat::subFloats(mid_float3, mid_float4);
    let mut temp = ZKFloat::divFloats(mid_float5, mid_float6);
    temp
}

fn calc_b(sum_x: ZKFloat::Float, sum_y: ZKFloat::Float, sum_xx: ZKFloat::Float, sum_xy: ZKFloat::Float) -> ZKFloat::Float{
    let mid_float1 = ZKFloat::mulFloats(ZKFloat::Float{sign:0, mantissa:6, exponent:100}, sum_xy);
    let mid_float2 = ZKFloat::mulFloats(sum_x, sum_y);
    let mid_float3 = ZKFloat::mulFloats(ZKFloat::Float{sign:0, mantissa:6, exponent:100}, sum_xx);
    let mid_float4 = ZKFloat::mulFloats(sum_x, sum_x);
    let mid_float5 = ZKFloat::subFloats(mid_float1, mid_float2);
    let mid_float6 = ZKFloat::subFloats(mid_float3, mid_float4);
    let mut temp = ZKFloat::divFloats(mid_float5, mid_float6);
    temp
}


fn count_sum(x: [Field; 18]) -> ZKFloat::Float{
    let mut temp =  ZKFloat::Float{sign:x[0], mantissa:x[1], exponent:x[2]};
    let mut index = 3;
    for i in 1..6{
        let midfloat = ZKFloat::Float{sign:x[index], mantissa:x[index+1], exponent:x[index+2]};
        temp = ZKFloat::addFloats(temp, midfloat);
        index+=3;
    }
    temp
}

fn mul_sum(x: [Field; 18], y:[Field; 18]) -> ZKFloat::Float{
    let mut mul_float : [ZKFloat::Float; 6] = [ZKFloat::Float{sign:0, mantissa:0, exponent:0}; 6];
    let mut index = 0;
    for i in 0..6{
        let midfloat = ZKFloat::mulFloats(ZKFloat::Float{sign: x[index], mantissa: x[index+1], exponent:x[index+2]}, ZKFloat::Float{sign: y[index], mantissa: y[index+1], exponent: y[index+2]});
        index+=3;
        mul_float[i] = midfloat;
    }
    let mut temp = ZKFloat::Float{sign:0, mantissa:0, exponent:100};
    for i in 0..6{
        temp = ZKFloat::addFloats(temp, mul_float[i]);
    }
    temp
}