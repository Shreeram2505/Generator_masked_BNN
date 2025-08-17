import torch

# ───────────── 2's Complement Conversion ─────────────
def bits_to_signed(x_bits: torch.LongTensor, n_bits=3):
    mod = 1 << n_bits
    half = 1 << (n_bits - 1)
    x = x_bits.clone()
    x[x >= half] -= mod
    return x

def signed_to_bits(x_signed: torch.LongTensor, n_bits=3):
    mod = 1 << n_bits
    return x_signed.remainder(mod).long()

# ───────────── Binary Linear Layer ─────────────
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

# ───────────── 32→16→8→4 BNN ─────────────
def bnn32_16_8_4_signed(x_bits, w1, b1, w2, b2, w3, b3, n_bits):
    h1_s = binary_layer_signed_raw(x_bits, w1, b1, n_bits)
    h1_act = (h1_s > 0).long()
    h1_bits = signed_to_bits(h1_act, n_bits)

    h2_s = binary_layer_signed_raw(h1_bits, w2, b2, n_bits)
    h2_act = (h2_s > 0).long()
    h2_bits = signed_to_bits(h2_act, n_bits)

    out_s = binary_layer_signed_raw(h2_bits, w3, b3, n_bits)
    out_bits = signed_to_bits(out_s, n_bits)
    return out_bits, out_s

# ───────────── MAIN ─────────────
if __name__ == "__main__":
    n_bits = 3
    x_bits = torch.tensor([[3, 6, 7, 1, 0, 2, 0, 6] * 4], dtype=torch.long)

    # w1: 16 neurons × 32-bit inputs
# Layer 1: 32 → 16
    w1 = torch.ones((16, 32), dtype=torch.long)
    b1 = torch.zeros(16, dtype=torch.long)

# Layer 2: 16 → 8
    w2 = torch.ones((8, 16), dtype=torch.long)
    b2 = torch.zeros(8, dtype=torch.long)

# Layer 3: 8 → 4
    w3 = torch.ones((4, 8), dtype=torch.long)
    b3 = torch.tensor([0, 2,1,0], dtype=torch.long)

    # Run BNN
    out_bits, out_signed = bnn32_16_8_4_signed(x_bits, w1, b1, w2, b2, w3, b3, n_bits)

    # Print summary
    print("Input (signed):      ", bits_to_signed(x_bits, n_bits).tolist()[0])
    print("Output (signed):     ", out_signed.tolist()[0])
    print("Output (3-bit bits): ", out_bits.tolist()[0])
