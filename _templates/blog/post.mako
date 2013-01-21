<%page args="post"/>

<% 
    category_links = []
    for category in post.categories:
        if post.draft:
            category_links.append(category.name)
        else:
            category_links.append("<a href='%s'>%s</a>" % (category.path, category.name))
%>

<article class="content_box">
	<div class="blog_post">
		<header>
			<div id="${post.slug}"></div>
			
			<h2 class="blog_post_title"><a href="${post.permapath()}" rel="bookmark" title="Permanent Link to ${post.title}">${post.title}</a></h2>
			
			% if hasattr(post, "subtitle"):
				<h3>${post.subtitle}</h3>
			% endif
			
			<p><small>
				<span class="blog_post_date">${post.date.strftime("%B %d, %Y")}</span>
				&nbsp;&nbsp;|&nbsp;&nbsp;
				categories: <span class="blog_post_categories">${", ".join(category_links)}</span>
			</small></p>
		</header>
		<div class="post_prose">
			${self.post_prose(post)}
		</div>
	</div>
</article>

<%def name="post_prose(post)">
	${post.content}
</%def>
