---
date: 2017-03-10 18:13:30-06:00
title: "Type-Safe Enum Strings in .NET"
description: ""
slug: "2008/08/18/type-safe-enum-strings-in-dotnet"
topics: ["technical"]
tags: ["enum"]
draft: false
---

One thing that has always bothered me in .NET is the inability to create a type-safe set of string constants like an enum. I would like to create a type such as the following:

```csharp
public enum StoredProcedure : string
{
   DeleteConsumer = "DeleteConsumer",
   EditConsumer = "EditConsumer",
   GetConsumer = "GetConsumer"
}
```

This would be incredibly useful for those situations where you are passing constant strings to a given method and you would like to limit the options that are passed to a finite set of options that can be detected through a type-safe check during compile time.

```csharp
public void ExecuteDataSet(StoredProcedures storedProcedure)
{
   SqlCommand command = new SqlCommand();
   command.CommandType = CommandType.StoredProcedure;
   command.CommandText = storedProcedure.ToString();
}
```

Unfortunately, a simple constant does not provide type-safe protection for the method call. If a developer is not aware of the pattern, they may end up sending in a literal string of their choosing. So, instead you end up with the following:

```csharp
public void ExecuteDataSet(string storedProcedure)
{
   SqlCommand command = new SqlCommand();
   command.CommandType = CommandType.StoredProcedure;
   command.CommandText = storedProcedure.ToString();
}
```

After working at a heterogeneous shop, I learned that Java has been creating their own type-safe string enum classes for solving this situation for years before the formal enum type was added to the 1.5 release of the Java Runtime.

The example below shows how a typical Java developer would implement this concept in Java syntax.

```csharp
public final class Color {

 private String name;

 private Color(String name) {
   this.name = name;
 }

 public String toString() {
   return this.id;
 }

 public static final Color RED = new Color("Red");
 public static final Color GREEN = new Color("Green");
 public static final Color BLUE = new Color("Blue");
} 
```

The basic idea is simple:

1. Define a class representing a single element of the enumerated type

2. Don't provide any public constructors for it.

3. Provide public static final fields, one for each constant in the enumerated type.

Because there is no way for clients to create objects of the type, there will never be any objects of the type besides those exported via the public static final fields.

In order to make this easier to use within .NET, I create an abstract base type, StringConstantBase, that allows a developer to quickly create the functionality above plus some other goodies such as GetNames(), CompareTo(), Equals(), GetHashCode(), and the == and != operators for comparison to string literals.

In order to use the code, you merely define your class as follows:

```csharp
public class StoredProcedures : StringConstantBase
{
   public static readonly StoredProcedures GetConsumer = new StoredProcedures("GetConsumer");
   public static readonly StoredProcedures EditConsumer = new StoredProcedures("EditConsumer");
   public static readonly StoredProcedures DeleteConsumer = new StoredProcedures("DeleteConsumer");

   private StoredProcedures(string name) : base(name){}

}
```

The only part that does not work (this is the same for the Java version) is that it cannot be used in switch...case statements. Those require the use of an underlying integral type which is not present. Instead, you should use the if...else if construct to perform the same logic.

If you are interested in using the StringConstantBase class for your own code, you can download my Visual Studio 2008 project from here. In addition to the class, I have included a unit test project to include my assumptions on its use.

I hope this helps someone out there...
