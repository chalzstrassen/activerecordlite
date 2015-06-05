# ActiveRecord Lite

## Getting Started

1. Run `bundle install`.
2. To run all of the tests: `rspec spec`.

## How to use

### Creating a Model

*Declare a Ruby class that inherits from `SQLObject`.*

```
class Cat < SQLObject
	finalize!
end
```

#### `save` and `update`

Models can be saved as tables in the database the same way with [Active Record](http://api.rubyonrails.org/classes/ActiveRecord/Persistence.html) in Rails.

#### 

`all`
Returns all records in the model
```
Cat.all  # => returns all rows in the cats table.
```

`find(id)`
Takes an id as a parameter and returns the record associated with the record.
```
Cat.find(1)  # => <Cat:0x007fd84adf6220 @attributes={:id=>1, :name=>"Breakfast", :owner_id=>1}>
```

### Associations

#### `belongs_to` Association
```
class Cat < SQLObject
	belongs_to :human

	finalize!
end

a = Cat.find(1)
a.human  #=> <Human:0x007fd84abd0630 @attributes={:id=>1, :fname=>"Dev", :lname=>"Britt">
```

#### `has_many` Association
```
class Human <SQLObject
	has_many: cats

	finalize!
end

b = Human.find(2)
b.cats #=> [<Cat:0x007fd84ad5e6f0 @attributes={:id=>2, :name=>"Earl", :owner_id=>2}>]
```

These two associations takes these options: `foreign_key`, `class_name`, and `primary_key`.

### Query Methods

#### `where` and `where2`

`where` and `where2` behaves similarly, but `where2` returns a Relation object and is chainable.

```
Human.where(fname: "Matt")  
  #=> [<Human:0x007fd84add58b8 @attributes={:id=>2, :fname=>"Matt", :lname=>"Rubens", :house_id=>1}>]
```

```
Cat.where2(owner_id: 3).where2(name: "Markov") 
  #=> <Relation:0x007fd84bb227f0
 @relations=[#<Cat:0x007fd84bb105a0 @attributes={:id=>4, :name=>"Markov", :owner_id=>3}>]>
```


