import Mathlib.Analysis.Calculus.ContDiff.Defs
import Mathlib.MeasureTheory.Integral.IntervalIntegral
import Mathlib.Analysis.Calculus.Deriv.Basic

open BigOperators

lemma sum_eq_int_deriv_aux2 {φ : ℝ → ℂ} {a b : ℝ} {k : ℤ}
    (φDiff : ContDiffOn ℝ 1 φ (Set.Icc a b)) :
    ∫ (x : ℝ) in a..b, (k + 1 / 2 - x) * deriv φ x =
      (k + 1 / 2 - b) * φ b - (k + 1 / 2 - a) * φ a + ∫ (x : ℝ) in a..b, φ x := by
  set v' := deriv φ
  set v := φ
  set u := fun (x : ℝ) ↦ (k + 1 / 2 - x : ℂ)
  set u' := fun (x : ℝ) ↦ (-1 : ℂ)
  have hu : ∀ x ∈ Set.uIcc a b, HasDerivAt u (u' x) x := by
    intros x hx
    -- convert HasDerivAt.add (f := fun (x : ℝ) ↦ (k + 1 / 2 : ℂ)) (g := fun (x : ℝ) ↦ (-x : ℂ))
    --   (f' := (0 : ℂ)) (g' := (-1 : ℂ)) ?_ ?_
    sorry
  have hv : ∀ x ∈ Set.uIcc a b, HasDerivAt v (v' x) x := by
    intros x hx
    sorry
  have hu' : IntervalIntegrable u' MeasureTheory.volume a b := sorry
  have hv' : IntervalIntegrable v' MeasureTheory.volume a b := sorry
--  have := intervalIntegral.integral_mul_deriv_eq_deriv_mul hu hu' hv hv'
  sorry

lemma sum_eq_int_deriv_aux_eq {φ : ℝ → ℂ} {a b : ℝ} {k : ℤ}
    (b_eq_kpOne : b = k + 1) (φDiff : ContDiffOn ℝ 1 φ (Set.Icc a b)) :
    ∑ n in Finset.Icc (k + 1) ⌊b⌋, φ n =
    (∫ x in a..b, φ x) + (⌊b⌋ + 1 / 2 - b) * φ b - (k + 1 / 2 - a) * φ a
      - ∫ x in a..b, (k + 1 / 2 - x) * deriv φ x := by
  have flb_eq_k : ⌊b⌋ = k + 1 := Int.floor_eq_iff.mpr ⟨by exact_mod_cast b_eq_kpOne.symm.le,
    by rw [b_eq_kpOne]; simp⟩
  simp_rw [flb_eq_k]
  simp only [Finset.Icc_self, Finset.sum_singleton, Int.cast_add, Int.cast_one]
  rw [sum_eq_int_deriv_aux2 φDiff]
  ring_nf
  rw [b_eq_kpOne]
  congr! 1
  ring_nf

lemma sum_eq_int_deriv_aux_lt {φ : ℝ → ℂ} {a b : ℝ} {k : ℤ} (k_le_a : k ≤ a) (a_lt_b : a < b)
    (b_lt_kpOne : b < k + 1) (φDiff : ContDiffOn ℝ 1 φ (Set.Icc a b)) :
    ∑ n in Finset.Icc (k + 1) ⌊b⌋, φ n =
    (∫ x in a..b, φ x) + (⌊b⌋ + 1 / 2 - b) * φ b - (k + 1 / 2 - a) * φ a
      - ∫ x in a..b, (k + 1 / 2 - x) * deriv φ x := by
  have flb_eq_k : ⌊b⌋ = k := Int.floor_eq_iff.mpr ⟨by linarith, by linarith⟩
  simp_rw [flb_eq_k]
  simp only [gt_iff_lt, lt_add_iff_pos_right, zero_lt_one, Finset.Icc_eq_empty_of_lt,
    Finset.sum_empty]
  rw [sum_eq_int_deriv_aux2 φDiff]
  ring_nf

lemma sum_eq_int_deriv_aux1 {φ : ℝ → ℂ} {a b : ℝ} {k : ℤ} (k_le_a : k ≤ a) (a_lt_b : a < b)
    (b_le_kpOne : b ≤ k + 1) (φDiff : ContDiffOn ℝ 1 φ (Set.Icc a b)) :
    ∑ n in Finset.Icc (k + 1) ⌊b⌋, φ n =
    (∫ x in a..b, φ x) + (⌊b⌋ + 1 / 2 - b) * φ b - (k + 1 / 2 - a) * φ a
      - ∫ x in a..b, (k + 1 / 2 - x) * deriv φ x := by
  by_cases h : b = k + 1
  · exact sum_eq_int_deriv_aux_eq h φDiff
  · have : b < k + 1 := Ne.lt_of_le h b_le_kpOne
    exact sum_eq_int_deriv_aux_lt k_le_a a_lt_b this φDiff

/-%%
\begin{lemma}[sum_eq_int_deriv_aux]\label{sum_eq_int_deriv_aux}\lean{sum_eq_int_deriv_aux}\leanok
  Let $k \le a < b\le k+1$, with $k$ an integer, and let $\phi$ be continuously differentiable on
  $[a, b]$.
  Then
  \[
  \sum_{a < n \le b} \phi(n) = \int_a^b \phi(x) \, dx + \left(\lfloor b \rfloor + \frac{1}{2} - b\right) \phi(b) - \left(\lceil a \rceil + \frac{1}{2} - a\right) \phi(a) - \int_a^b \left(\lceil x \rceil + \frac{1}{2} - x\right) \phi'(x) \, dx.
  \]
\end{lemma}
%%-/
/-- Note: Need to finish proof of `sum_eq_int_deriv_aux2` -/
lemma sum_eq_int_deriv_aux {φ : ℝ → ℂ} {a b : ℝ} {k : ℤ} (k_le_a : k ≤ a) (a_lt_b : a < b)
    (b_le_kpOne : b ≤ k + 1) (φDiff : ContDiffOn ℝ 1 φ (Set.Icc a b)) :
    ∑ n in Finset.Icc (⌊a⌋ + 1) ⌊b⌋, φ n =
    (∫ x in a..b, φ x) + (⌊b⌋ + 1 / 2 - b) * φ b - (⌊a⌋ + 1 / 2 - a) * φ a
      - ∫ x in a..b, (⌊x⌋ + 1 / 2 - x) * deriv φ x := by
  have fl_a_eq_k : ⌊a⌋ = k := Int.floor_eq_iff.mpr ⟨k_le_a, by linarith⟩
  convert sum_eq_int_deriv_aux1 k_le_a a_lt_b b_le_kpOne φDiff using 2
  · congr
  · congr
  apply intervalIntegral.integral_congr_ae
  have :  ∀ᵐ (x : ℝ) ∂MeasureTheory.volume, x ≠ b := by
    convert Set.Countable.ae_not_mem (s := {b}) (by simp) (μ := MeasureTheory.volume) using 1
  filter_upwards [this]
  intro x x_ne_b hx
  congr
  rw [Set.uIoc_of_le a_lt_b.le, Set.mem_Ioc] at hx
  refine Int.floor_eq_iff.mpr ⟨by linarith, ?_⟩
  have : x < b := Ne.lt_of_le x_ne_b hx.2
  linarith
/-%%
\begin{proof}\leanok
Partial integration.
\end{proof}
%%-/

/-%%
\begin{lemma}[sum_eq_int_deriv]\label{sum_eq_int_deriv}\lean{sum_eq_int_deriv}\leanok
  Let $a < b$, and let $\phi$ be continuously differentiable on $[a, b]$.
  Then
  \[
  \sum_{a < n \le b} \phi(n) = \int_a^b \phi(x) \, dx + \left(\lfloor b \rfloor + \frac{1}{2} - b\right) \phi(b) - \left(\lceil a \rceil + \frac{1}{2} - a\right) \phi(a) - \int_a^b \left(\lceil x \rceil + \frac{1}{2} - x\right) \phi'(x) \, dx.
  \]
\end{lemma}
%%-/
/-- ** Partial summation ** (TODO : Add to Mathlib) -/
theorem sum_eq_int_deriv (φ : ℝ → ℂ) (a b : ℝ) (φDiff : ContDiffOn ℝ 1 φ (Set.Icc a b)) :
    ∑ n in Finset.Icc (⌊a⌋ + 1) ⌊b⌋, φ n =
    (∫ x in a..b, φ x) + (⌊b⌋ + 1 / 2 - b) * φ b - (⌊a⌋ + 1 / 2 - a) * φ a
      - ∫ x in a..b, (⌊x⌋ + 1 / 2 - x) * deriv φ x := by
  sorry
/-%%
\begin{proof}\uses{sum_eq_int_deriv_aux}
  Apply Lemma \ref{sum_eq_int_deriv_aux} in blocks of length $\le 1$.
\end{proof}
%%-/
