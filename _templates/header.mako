
<header>
	<div id="header" class="grid_12">
		<div id="header_title"><a href="${bf.util.site_path_helper()}">${bf.config.blog.name}</a></div>
		<!--<h2>${bf.config.blog.description}</h2> -->
	</div>
	<div id="navigation" class="grid_12">
		<%
		def nav_class(path):
			render_path = bf.template_context.render_path.rsplit("/index.html")[0]
			if render_path == path or (path == "/" and render_path == ".\index.html") or render_path.replace("\\", "/") == (path + "/index.html"):
				return "selected"
			return ""
		%>
		<ul>
			<li><a href="${bf.util.site_path_helper()}"class="${nav_class(bf.util.site_path_helper())}">Home</a></li>
			<li><a href="${bf.util.site_path_helper(bf.config.blog.path,'')}"class="${nav_class(bf.util.site_path_helper(bf.config.blog.path,''))}">Blog</a></li>
			<li><a href="${bf.util.site_path_helper(bf.config.blog.path,'archive')}"class="${nav_class(bf.util.site_path_helper(bf.config.blog.path,'archive'))}">Archives</a></li>
		</ul>
	</div>
</header>
