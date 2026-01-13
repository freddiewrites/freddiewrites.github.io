---
layout: page
title: Posts
permalink: /posts/
---

<section class="posts">
{% assign posts_by_year = site.posts | group_by_exp: "post", "post.date | date: '%Y'" %}

{% for year_group in posts_by_year %}
  <h2>{{ year_group.name }}</h2>
  {% for post in year_group.items %}
    {% include post-card.html %}
  {% endfor %}
{% endfor %}
</section>
