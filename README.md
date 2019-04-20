
## Blog
> my own blog server based on github.io and hexo.

[https://carl-zk.github.io/blog/](https://carl-zk.github.io/blog/)

## Get Start
Two ways for choice: docker or normal.
### start with docker
Thanks for [https://github.com/flink-china/flink-china-doc](https://github.com/flink-china/flink-china-doc). Inspired by this project, I start to use docker to maintain my blog distrubution.
```sh
git clone git@github.com:carl-zk/blog.git
cd blog
docker/run.sh
```
visit in browser: [localhost:4000](http://localhost:4000)

### Pre Request
- [hexo](https://hexo.io/)
- [yarn](https://yarnpkg.com/en/)

### Install 
```sh
git clone git@github.com:carl-zk/blog.git
cd blog
yarn install
hexo s -g
```
visit in browser: [localhost:4000](http://localhost:4000)

## Appendix
设置分页
```
vi node_modules/hexo-generator-index/index.js
vi node_modules/hexo-generator-archive/index.js
vi node_modules/hexo-generator-category/index.js
vi node_modules/hexo-generator-tag/index.js
```


