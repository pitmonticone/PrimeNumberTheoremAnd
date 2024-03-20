import Mathlib.Analysis.Distribution.SchwartzSpace
import Mathlib.Analysis.Fourier.FourierTransformDeriv
import Mathlib.MeasureTheory.Integral.IntegralEqImproper
import Mathlib.Topology.ContinuousFunction.Bounded

open FourierTransform Real Complex MeasureTheory Filter Topology BoundedContinuousFunction SchwartzMap

@[simp]
theorem nnnorm_eq_of_mem_circle (z : circle) : ‖z.val‖₊ = 1 := NNReal.coe_eq_one.mp (by simp)

@[simp]
theorem nnnorm_circle_smul (z : circle) (s : ℂ) : ‖z • s‖₊ = ‖s‖₊ := by
  simp [show z • s = z.val * s from rfl]

noncomputable def e (u : ℝ) : ℝ →ᵇ ℂ where
  toFun v := 𝐞 [-v * u]
  continuous_toFun := by simp only [Multiplicative.ofAdd] ; have := continuous_fourierChar ; continuity
  map_bounded' := ⟨2, fun x y => (dist_le_norm_add_norm _ _).trans (by simp [one_add_one_eq_two])⟩

@[simp] lemma e_apply (u : ℝ) (v : ℝ) : e u v = 𝐞 [-v * u] := rfl

theorem hasDerivAt_e {u x : ℝ} : HasDerivAt (e u) (-2 * π * u * I * e u x) x := by
  have l2 : HasDerivAt (fun v => -v * u) (-u) x := by simpa only [neg_mul_comm] using hasDerivAt_mul_const (-u)
  convert (hasDerivAt_fourierChar (-x * u)).scomp x l2 using 1
  simp ; ring

lemma fourierIntegral_deriv_aux2 (e : ℝ →ᵇ ℂ) {f : ℝ → ℂ} (hf : Integrable f) : Integrable (⇑e * f) :=
  hf.bdd_mul e.continuous.aestronglyMeasurable ⟨_, e.norm_coe_le_norm⟩

lemma fourierIntegral_deriv_aux1 (e : ℝ →ᵇ ℂ) (ψ : 𝓢(ℝ, ℂ)) : Integrable (⇑e * ⇑ψ) :=
  fourierIntegral_deriv_aux2 e ψ.integrable

theorem fourierIntegral_deriv {f f' : ℝ → ℂ} (h1 : ∀ x, HasDerivAt f (f' x) x) (h2 : Integrable f)
    (h3 : Integrable f') (h4 : Tendsto f (cocompact ℝ) (𝓝 0)) (u : ℝ) :
    𝓕 f' u = 2 * π * I * u * 𝓕 f u := by
  convert_to ∫ v, e u v * f' v = 2 * ↑π * I * ↑u * ∫ v, e u v * f v
    <;> try { simp [fourierIntegral_real_eq] }
  have l1 (x) : HasDerivAt (e u) (-2 * π * u * I * e u x) x := hasDerivAt_e
  have l3 : Integrable (⇑(e u) * f') := fourierIntegral_deriv_aux2 (e u) h3
  have l4 : Integrable (fun x ↦ -2 * π * u * I * e u x * f x) := by
    simpa [mul_assoc] using (fourierIntegral_deriv_aux2 (e u) h2).const_mul (-2 * π * u * I)
  have l7 : Tendsto (⇑(e u) * f) (cocompact ℝ) (𝓝 0) := by
    simpa [tendsto_zero_iff_norm_tendsto_zero] using h4
  have l5 : Tendsto (⇑(e u) * f) atBot (𝓝 0) := l7.mono_left _root_.atBot_le_cocompact
  have l6 : Tendsto (⇑(e u) * f) atTop (𝓝 0) := l7.mono_left _root_.atTop_le_cocompact
  rw [integral_mul_deriv_eq_deriv_mul l1 h1 l3 l4 l5 l6]
  simp [integral_neg, ← integral_mul_left] ; congr ; ext ; ring

theorem fourierIntegral_deriv_schwartz (ψ : 𝓢(ℝ, ℂ)) (u : ℝ) : 𝓕 (deriv ψ) u = 2 * π * I * u * 𝓕 ψ u :=
  fourierIntegral_deriv (fun _ => ψ.differentiableAt.hasDerivAt) ψ.integrable
    (SchwartzMap.derivCLM ℝ ψ).integrable ψ.toZeroAtInfty.zero_at_infty' u

theorem fourierIntegral_deriv_compactSupport {f : ℝ → ℂ} (h1 : ContDiff ℝ 1 f) (h2 : HasCompactSupport f) (u : ℝ) :
    𝓕 (deriv f) u = 2 * π * I * u * 𝓕 f u := by
  have l1 (x) : HasDerivAt f (deriv f x) x := (h1.differentiable le_rfl).differentiableAt.hasDerivAt
  have l2 : Integrable f := h1.continuous.integrable_of_hasCompactSupport h2
  have l3 : Integrable (deriv f) := (h1.continuous_deriv le_rfl).integrable_of_hasCompactSupport h2.deriv
  exact fourierIntegral_deriv l1 l2 l3 h2.is_zero_at_infty u
