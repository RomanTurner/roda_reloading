# roda_reloading

This project was practice setting up Zeitwerk with Dry-System and Roda for the purpose of code reloading during development.

I arrived at this point for as an exploration on creating my own framework using Roda. I want to be able to share this with other people, and the only way that I will be able to do that is if I can offer what other frameworks in our community offer. In this project, that is specifically the feature of code reloading.

The path getting here was a bumpy one, and there are a lot of things to still work out. [There is a tale to be told](##story-time)

The directory structure is not the traditional "MVC" or bucket system. It is based on allocating resources and the locality of behavior. It looks like such:

```ruby
project
│   README.md
│   app.rb
|   config.ru
│
└───allocs
│   │
│   └─── users
│       │   data_model.rb
│       │   routes.rb
│       │   name_decorator.rb
│   │
│   └─── posts
│       │   data_model.rb
│       │   routes.rb
│       │   publisher.rb
|
└───system
```

To run, clone the repo down and run these commands in the terminal.

```bash
$ bundle install
$ rackup
```

## Story Time

I initially started with Zeitwerk, and ran into an issue with loading a constant that is split between multiple files. Roda routing files are like that when you are using the hash_branches plugin.

I was like, 'fuck it' and decided to try to get Rack::Unreloader to work for the project. I am already using Roda and Sequel, might as well 'all-in' on the "JERMSTACK".

That did not work out how I hoped. I had issues parsing the documentation on how to get it all tied together the way I wanted. I don't want this framework to follow the same 'buckets' mentality of other projects like Rails. I want locality of behavior.

So, I went back to Zeitwerk because it has features like, ignoring and collapsing and the documentation is well done.
When I made that decision I was looking into how Hanami worked things out, but they are some big-brained giga chads on that project and I am on the grug train. But I did wander into Dry-System and enjoyed how encapsulated the providers were. I don't want to have to load my entire application if I just need database access, or loader access, or environment access. Dry-System can give me that.

That being said, I am new to it so it is probably not the best configuration. Hell, I am not even using the Zeitwerk plugin appropriately or at all. I am using some techniques that I found in the book "Ruby on Roda" by Mateusz Urbanski (system/loader.rb) and that was written before the Zeitwerk plugin.

At the time when configuring I thought I needed more advanced things like:

```ruby
loader.collapse('#{__dir__}/*/views/*')
loader.ignore('allocs/*/routes.rb')
loader.load_file('app.rb')
```

With Zeitwerk not liking the constant `App` in `allocs/*/routes.rb` That was issue #1.

That was fine if I ignored it and required the files in `app.rb` but how do you get code reloading for the subpath hash_branches?

I tried to load the single file using `loader.load_file('app.rb')` but I kept getting `I do not manage 'app.rb'` errors from Zeitwerk, it is like, 'yeah, I know, I want you to manage it you dumbo.' I couldn't find anything about that online.

**Only For the haters out there**

I am not a bad googler and I went through all the github issues and discussions and different discussion board threads. Its a barren landscape for users of Zeitwerk without using the Gem::Inflector or Rails so bite me.

**Back to Story Time**

Okay, so that was a big problem. After thinking about it for a while I have had a thought about mounting another Roda app as the individual route instead of the branch. That way you can also get the namespacing along with just having Zeitwerk load all the routes as constants i.e. `User::Routes`

That worked! I know there are probably performance issues, but I don't think anything that would be worse that trying to find another solution to the code reloading issue. Rack middleware are just rack apps, Roda is just a rack app, I don't think it is going to be a big hit.

I added some metaprogramming to add the routes if the convention is followed:

`alloc/domain/routes.rb`

alloc - allocation of application state.

domain - the resource you are targeting.

routes - the routes for that resource.

an example:
```ruby
#allocs/user/routes.rb
module User
  class Routes < Roda
  ...
  end
end
```
