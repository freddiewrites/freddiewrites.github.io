---
layout: page
title: Posts
permalink: /posts/
---

<section class="posts">
{% assign posts_by_year = site.posts | group_by_exp: "post", "post.date | date: '%Y'" %}

{% for year_group in posts_by_year %}
  {% assign year_has_posts = false %}
  {% for post in year_group.items %}
    {% assign skip_post = false %}
    {% if post.tags contains 'now' %}
      {% assign skip_post = true %}
    {% endif %}
    {% if jekyll.environment == 'production' and post.title == 'Style Guide' %}
      {% assign skip_post = true %}
    {% endif %}
    {% unless skip_post %}
      {% assign year_has_posts = true %}
      {% break %}
    {% endunless %}
  {% endfor %}
  {% if year_has_posts %}
    <h2>{{ year_group.name }}</h2>
    {% for post in year_group.items %}
      {% assign skip_post = false %}
      {% if post.tags contains 'now' %}
        {% assign skip_post = true %}
      {% endif %}
      {% if jekyll.environment == 'production' and post.title == 'Style Guide' %}
        {% assign skip_post = true %}
      {% endif %}
      {% unless skip_post %}
        {% include post-card.html %}
      {% endunless %}
    {% endfor %}
  {% endif %}
{% endfor %}
</section>
