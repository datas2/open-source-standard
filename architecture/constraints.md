# Why it is important?
Once we identify system constraints, we shouldn’t overlook them. Some constraints are clear and based on hard facts, while others may be self-imposed, like budget or time limitations, which can often be negotiated or adjusted.

Another approach is to design a loosely coupled architecture based on the current constraints, allowing us to easily replace or modify components in the future if those constraints are lifted.

For example, if we are limited to a specific database or third-party API, we must ensure that our system is not tightly coupled to that technology, allowing us to replace it with minimal refactoring when needed.

# Executive Summary

# 1. Technical Constraint
This is something that we deal with everyday and not something that new to the developers.

For example, Locked into a particular software platform or cloud vendor, having to use particular programming language or technology, having to particular database technology, having to support certain platforms, browsers or OS.

At first glance, technical constraints may seem directly tied to implementation. However, in reality, they influence our decisions during the design phase and impose limitations on our architecture.

Let’s consider another example: if we need to deploy our service on on-premise data centers, we must take into account the cloud architectures and paradigms that are unavailable to us in this setup.

# 2. Business Constraint
As engineers, we aim to make the right decisions and architectural choices from a technical standpoint. However, there are times when we must compromise on these decisions in implementation and architecture due to business constraints.

For example, Limited budget or a strict deadline will make us have very different choices than if we had an unlimited budget and unlimited time :)

Another example is how different software architecture patterns are chosen based on the specific needs of an organization, which often vary between small startups and larger enterprises. For instance, a startup might opt for a simpler, more agile architecture pattern that allows for rapid development and iteration, given their smaller budget and limited manpower. This might include microservices or serverless approaches that are easier to scale up quickly as the company grows.

# 3. Legal Constraints
These types of constraints are may be global or specific to a certain regions based on countries rules/ laws and government decisions.

For example, in the USA, if you develop a system related to healthcare, you must comply with HIPAA regulations. Similarly, in the European Union, GDPR imposes restrictions on the collection, storage, and sharing of user data.

So depending the geographical location, we many have to follow certain regulations that affect the architecture of the system.