### A Pluto.jl notebook ###
# v0.19.26

using Markdown
using InteractiveUtils

# ╔═╡ 860e2922-6ae3-11ee-0d3b-972695eeda55
# ╠═╡ show_logs = false
using Pkg; Pkg.activate("."); Pkg.instantiate()

# ╔═╡ 7732b0b0-373d-4f3d-814a-3887dcecd865
using MaterialDecomposition

# ╔═╡ 052c0ccb-838b-4813-917e-d6ef88abdab0
using PlutoUI

# ╔═╡ e995663f-6058-4bb9-a878-cb1f3299757f
#> [frontmatter]
#> title = "API"
#> category = "API"

# ╔═╡ a480a678-73cc-4f82-8a94-a213f602eef7
TableOfContents()

# ╔═╡ c4e6107e-992f-4bef-87d4-ff87270512ad
all_names = [name for name in names(MaterialDecomposition)];

# ╔═╡ 43a404d1-75b3-48b3-8201-d2f6891a8331
exported_functions = filter(x -> x != :MaterialDecomposition, all_names);

# ╔═╡ 61173101-7f44-4982-92a3-5d484a41d6e1
function generate_docs(exported_functions)
    PlutoUI.combine() do Child
        md"""
        $([md" $(Docs.doc(eval(name)))" for name in exported_functions])
        """
    end
end;

# ╔═╡ bea1ea5e-abde-4ca4-b557-3fc197b26f98
generate_docs(exported_functions)

# ╔═╡ Cell order:
# ╟─bea1ea5e-abde-4ca4-b557-3fc197b26f98
# ╟─e995663f-6058-4bb9-a878-cb1f3299757f
# ╟─860e2922-6ae3-11ee-0d3b-972695eeda55
# ╟─7732b0b0-373d-4f3d-814a-3887dcecd865
# ╟─052c0ccb-838b-4813-917e-d6ef88abdab0
# ╟─a480a678-73cc-4f82-8a94-a213f602eef7
# ╟─c4e6107e-992f-4bef-87d4-ff87270512ad
# ╟─43a404d1-75b3-48b3-8201-d2f6891a8331
# ╟─61173101-7f44-4982-92a3-5d484a41d6e1
