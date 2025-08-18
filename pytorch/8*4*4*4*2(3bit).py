import torch

# ───────────────────────────────────────────────────────────────
# Two's complement conversion helpers
# ───────────────────────────────────────────────────────────────

def bits_to_signed(x_bits: torch.LongTensor, n_bits: int = 3) -> torch.LongTensor:
    mod = 1 << n_bits
    half = 1 << (n_bits - 1)
    x = x_bits.clone()
    x[x >= half] -= mod
    return x

def signed_to_bits(x_signed: torch.LongTensor, n_bits: int = 3) -> torch.LongTensor:
    mod = 1 << n_bits
    return x_signed.remainder(mod).long()

# ───────────────────────────────────────────────────────────────
# Bit-serial signed binary linear layer
# ───────────────────────────────────────────────────────────────

def binary_layer_signed_raw(x_bits, w_bits, b_bits=None, n_bits=3):
    x_s = bits_to_signed(x_bits, n_bits)
    b_s = bits_to_signed(b_bits, n_bits) if b_bits is not None else None

    x_exp = x_s.unsqueeze(1).expand(-1, w_bits.shape[0], -1)  # [B, out_f, in_f]
    sign = w_bits.unsqueeze(0) * 2 - 1
    contrib = x_exp * sign

    y_s = contrib.sum(dim=2)
    if b_s is not None:
        y_s += b_s.unsqueeze(0)
    return y_s

# ───────────────────────────────────────────────────────────────
# 8→4→4→4->2 BNN forward pass
# ───────────────────────────────────────────────────────────────

def bnn8_4_4_4_2signed(
    x_bits: torch.LongTensor,
    w1: torch.LongTensor, b1: torch.LongTensor,
    w2: torch.LongTensor, b2: torch.LongTensor,
    w3: torch.LongTensor, b3: torch.LongTensor,
    w4: torch.LongTensor, b4: torch.LongTensor,

    n_bits: int = 3
) -> torch.LongTensor:
    # Layer 1: 8 → 4
    h1_s = binary_layer_signed_raw(x_bits, w1, b1, n_bits)
    h1_act = (h1_s > 0).long()
    h1_bits = signed_to_bits(h1_act, n_bits)

    # Layer 2: 4 → 4
    h2_s = binary_layer_signed_raw(h1_bits, w2, b2, n_bits)
    h2_act = (h2_s > 0).long()
    h2_bits = signed_to_bits(h2_act, n_bits)

    # Layer 3: 4 → 4 
    h3_s = binary_layer_signed_raw(h2_bits, w3, b3, n_bits)
    h3_act = (h3_s > 0).long()
    h3_bits = signed_to_bits(h3_act, n_bits)

    # Layer 4: 4 → 2 (output)
    out_s = binary_layer_signed_raw(h3_bits, w4, b4, n_bits)
    out_bits = signed_to_bits(out_s, n_bits)
    return out_bits

# ───────────────────────────────────────────────────────────────
# Example usage
# ───────────────────────────────────────────────────────────────

if __name__ == "__main__":
    n_bits = 3
    B = 1  # batch size

    # Input: 1 sample of 16 3-bit values
    x_bits = torch.tensor([[2, 2, 3, 3, 5, 6, 7, 6]], dtype=torch.long)

    # Weights: all binary (0/1)
    w1 = torch.tensor([
    [1, 1, 1, 1, 0, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1, 1],
    ], dtype=torch.long)

    # w2: 4 → 4, all ones
    w2 = torch.tensor([
        [1, 1, 1, 1],
        [1, 1, 1, 1],
        [1, 1, 1, 1],
        [1, 1, 1, 1],
    ], dtype=torch.long)

    # w3: 4 → 4, all ones
    w3 = torch.tensor([
        [1, 1, 1, 1],
        [1, 1, 1, 1],
        [1, 1, 1, 1],
        [1, 1, 1, 1],
    ], dtype=torch.long)

    # w4: 4 → 2, all ones
    w4 = torch.tensor([
        [1, 1, 1, 1],
        [1, 1, 1, 1],
    ], dtype=torch.long)

    # Biases: 3-bit format (0–7)
   # b1: 4 biases for layer 1
    b1 = torch.tensor([0, 0, 0, 0], dtype=torch.long)

    # b2: 4 biases for layer 2
    b2 = torch.tensor([1, 1, 1, 1], dtype=torch.long)

    # b3: 4 biases for layer 2
    b3 = torch.tensor([0, 0, 0, 0], dtype=torch.long)

    # b4: 2 biases for output layer
    b4 = torch.tensor([2, 0], dtype=torch.long)


    # Run model
    out_bits = bnn8_4_4_4_2signed(x_bits, w1, b1, w2, b2, w3, b3, w4, b4, n_bits)

    # Debug prints
   # Input and signed interpretation
print("Input (bits):       ", x_bits.tolist()[0])
print("Input (signed):     ", bits_to_signed(x_bits, n_bits).tolist()[0])

# ───── Layer 1: 8 → 4 ─────
print("\nW1 bits:\n", w1.tolist(), "\nB1 bits:", b1.tolist())
h1_s = binary_layer_signed_raw(x_bits, w1, b1, n_bits)
print("Hidden Layer 1 pre-activation (signed):", h1_s.tolist()[0])
h1_act = (h1_s > 0).long()
print("Hidden Layer 1 activation (0/1):       ", h1_act.tolist()[0])
h1_bits = signed_to_bits(h1_act, n_bits)
print("Hidden Layer 1 activation (bits):      ", h1_bits.tolist()[0])

# ───── Layer 2: 4 → 4 ─────
print("\nW2 bits:\n", w2.tolist(), "\nB2 bits:", b2.tolist())
h2_s = binary_layer_signed_raw(h1_bits, w2, b2, n_bits)
print("Hidden Layer 2 pre-activation (signed):", h2_s.tolist()[0])
h2_act = (h2_s > 0).long()
print("Hidden Layer 2 activation (0/1):       ", h2_act.tolist()[0])
h2_bits = signed_to_bits(h2_act, n_bits)
print("Hidden Layer 2 activation (bits):      ", h2_bits.tolist()[0])

# ───── Layer 3: 4 → 4 ─────
print("\nW2 bits:\n", w3.tolist(), "\nB3 bits:", b3.tolist())
h3_s = binary_layer_signed_raw(h2_bits, w3, b3, n_bits)
print("Hidden Layer 3 pre-activation (signed):", h3_s.tolist()[0])
h3_act = (h3_s > 0).long()
print("Hidden Layer 3 activation (0/1):       ", h3_act.tolist()[0])
h3_bits = signed_to_bits(h3_act, n_bits)
print("Hidden Layer 3 activation (bits):      ", h3_bits.tolist()[0])

# ───── Output Layer: 4 → 2 ─────
print("\nW3 bits:\n", w4.tolist(), "\nB4 bits:", b4.tolist())
out_s = binary_layer_signed_raw(h3_bits, w4, b4, n_bits)
print("Output pre-activation (signed):        ", out_s.tolist()[0])
out_bits = signed_to_bits(out_s, n_bits)
print("Output (bits):                         ", out_bits.tolist()[0])
print("Output (signed):                       ", bits_to_signed(out_bits, n_bits).tolist()[0])

