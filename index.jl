### A Pluto.jl notebook ###
# v0.19.26

#> [frontmatter]
#> title = "MaterialDecomposition.jl"
#> sidebar = "false"

using Markdown
using InteractiveUtils

# ╔═╡ 84b10fbd-3f05-4377-8f1f-7777d356b873
# ╠═╡ show_logs = false
using Pkg; Pkg.activate(joinpath(pwd(), "docs")); Pkg.instantiate()

# ╔═╡ 1a7bc160-7c5c-4d4b-9bde-e0bb972e5d3f
using PlutoUI

# ╔═╡ 989cbb19-cceb-49bf-823d-5ac6f2b9418f
using HTMLStrings: to_html, head, link, script, divv, h1, img, p, span, a, figure, hr

# ╔═╡ 45d468eb-58e6-4170-9fcd-b25276530834
md"""
## Tutorials
"""

# ╔═╡ bafc0b66-e10d-4a23-8230-f0c3956c9581
md"""
## API
"""

# ╔═╡ 07565aa1-e2d7-4aa8-8fd4-4e294aaf549a
to_html(hr())

# ╔═╡ 9d05688b-d3bd-44f3-ac55-2711b19200f7
TableOfContents()

# ╔═╡ 821370d1-ad61-41e1-94c1-add3e46853ea
data_theme = "pastel";

# ╔═╡ a81e46d6-be99-4d32-a4db-4e03167d1de1
function index_title_card(title::String, subtitle::String, image_url::String; data_theme::String = "pastel", border_color::String = "primary")
	return to_html(
	    divv(
	        head(
				link(:href => "https://cdn.jsdelivr.net/npm/daisyui@3.7.4/dist/full.css", :rel => "stylesheet", :type => "text/css"),
	            script(:src => "https://cdn.tailwindcss.com")
	        ),
			divv(:data_theme => "$data_theme", :class => "card card-bordered flex justify-center items-center border-$border_color text-center w-full dark:text-[#e6e6e6]",
				divv(:class => "card-body flex flex-col justify-center items-center",
					img(:src => "$image_url", :class => "h-20 w-20 md:h-40 md:w-40 rounded-md", :alt => "$title Logo"),
					divv(:class => "text-5xl font-bold bg-gradient-to-r from-accent to-primary inline-block text-transparent bg-clip-text py-10", "$title"),
					p(:class => "card-text text-md font-serif", "$subtitle"
					)
				)
			)
	    )
	)
end;

# ╔═╡ 486152c5-4ef0-43d5-90a2-2d773ff92aca
index_title_card(
	"MaterialDecomposition.jl",
	"Multi-Energy Algorithms for Quantifying Materials in CT Images",
	"https://img.freepik.com/free-vector/led-video-wall-screen-texture-background-blue-purple-color-light-diode-dot-grid-tv-panel-lcd-display-with-pixels-pattern-television-digital-monitor-realistic-3d-vector-illustration_107791-3062.jpg";
	data_theme = data_theme
)

# ╔═╡ cf95adca-f2ac-4f00-b030-5dcc6a42b826
struct Article
	title::String
	path::String
	image_url::String
end

# ╔═╡ 24f8322e-a47d-4909-9a96-c8907da68400
article_list_tutorials = Article[
	Article("Getting Started", "docs/01_getting_started.jl", "https://img.freepik.com/free-photo/futuristic-spaceship-takes-off-into-purple-galaxy-fueled-by-innovation-generated-by-ai_24640-100023.jpg"),
	Article("Calcium Quantification", "docs/02_calcium_quantification.jl", "https://img.freepik.com/premium-vector/calcium-float-out-bone-capsule-help-heal-arthritis-knee-joint-pain-leg-healthy-bones_228260-720.jpg"),
	Article("Water/Lipid Quantification", "docs/03_water_lipid_quantification.jl", "https://img.freepik.com/free-vector/cholesteral-human-heart_1308-33171.jpg"),
];

# ╔═╡ 5bdfd581-3b45-4e4d-a6ec-9d0ef0c11136
article_list_api = Article[
	Article("API", "docs/api.jl", "https://img.freepik.com/free-photo/modern-technology-workshop-creativity-innovation-communication-development-generated-by-ai_188544-24548.jpg"),
];

# ╔═╡ 633a1fef-eb08-4867-b68a-d1aa8347cb56
function article_card(article::Article, color::String; data_theme = "pastel")
    a(:href => article.path, :class => "w-1/2 p-2",
		divv(:data_theme => "$data_theme", :class => "card card-bordered border-$color text-center dark:text-[#e6e6e6]",
			divv(:class => "card-body justify-center items-center",
				p(:class => "card-title", article.title),
				p("Click to open the notebook")
			),
			figure(
				img(:class => "w-full h-48", :src => article.image_url, :alt => article.title)
			)
        )
    )
end;

# ╔═╡ 93225b93-a766-43a2-a394-6c6157b0bd37
to_html(
    divv(:class => "flex flex-wrap justify-center items-start",
        [article_card(article, "accent"; data_theme = data_theme) for article in article_list_tutorials]...
    )
)

# ╔═╡ e925ea0e-ee36-4cb2-a7d7-ba4741798a2d
to_html(
    divv(:class => "flex flex-wrap justify-center items-start",
        [article_card(article, "secondary"; data_theme = data_theme) for article in article_list_api]...
    )
)

# ╔═╡ Cell order:
# ╟─486152c5-4ef0-43d5-90a2-2d773ff92aca
# ╟─45d468eb-58e6-4170-9fcd-b25276530834
# ╟─93225b93-a766-43a2-a394-6c6157b0bd37
# ╟─bafc0b66-e10d-4a23-8230-f0c3956c9581
# ╟─e925ea0e-ee36-4cb2-a7d7-ba4741798a2d
# ╟─07565aa1-e2d7-4aa8-8fd4-4e294aaf549a
# ╟─84b10fbd-3f05-4377-8f1f-7777d356b873
# ╟─1a7bc160-7c5c-4d4b-9bde-e0bb972e5d3f
# ╟─989cbb19-cceb-49bf-823d-5ac6f2b9418f
# ╟─9d05688b-d3bd-44f3-ac55-2711b19200f7
# ╟─821370d1-ad61-41e1-94c1-add3e46853ea
# ╟─a81e46d6-be99-4d32-a4db-4e03167d1de1
# ╟─cf95adca-f2ac-4f00-b030-5dcc6a42b826
# ╟─24f8322e-a47d-4909-9a96-c8907da68400
# ╟─5bdfd581-3b45-4e4d-a6ec-9d0ef0c11136
# ╟─633a1fef-eb08-4867-b68a-d1aa8347cb56
