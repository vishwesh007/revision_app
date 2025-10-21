import json

# Advanced Java topics with tricky, hard, and important interview questions
questions_data = []

# Starting IDs
question_start_id = 201
choice_start_id = 801

# Topics and their question sets
topics = {
    "Core Java Advanced": [
        {
            "prompt": "What happens when you call System.exit(0) in a finally block?",
            "type": "mcq",
            "choices": [
                {"text": "The finally block completes and then exits", "correct": False},
                {"text": "JVM exits immediately without completing finally", "correct": True},
                {"text": "Throws IllegalStateException", "correct": False},
                {"text": "The exit is deferred until finally completes", "correct": False}
            ]
        },
        {
            "prompt": "Which statements about String interning are true?",
            "type": "multi-select",
            "choices": [
                {"text": "intern() returns a reference from the string pool", "correct": True},
                {"text": "String literals are automatically interned", "correct": True},
                {"text": "new String() is automatically interned", "correct": False},
                {"text": "Interning can reduce memory usage for duplicate strings", "correct": True}
            ]
        },
        {
            "prompt": "What is the result of: Integer a = 128; Integer b = 128; a == b?",
            "type": "mcq",
            "choices": [
                {"text": "true", "correct": False},
                {"text": "false", "correct": True},
                {"text": "Compilation error", "correct": False},
                {"text": "Depends on JVM implementation", "correct": False}
            ]
        },
        {
            "prompt": "What is the difference between fail-fast and fail-safe iterators?",
            "type": "mcq",
            "choices": [
                {"text": "Fail-fast throws ConcurrentModificationException, fail-safe doesn't", "correct": True},
                {"text": "Fail-safe throws exceptions, fail-fast doesn't", "correct": False},
                {"text": "Both throw the same exception", "correct": False},
                {"text": "No difference", "correct": False}
            ]
        },
        {
            "prompt": "Which features were introduced in Java 17?",
            "type": "multi-select",
            "choices": [
                {"text": "Sealed classes", "correct": True},
                {"text": "Pattern matching for switch", "correct": True},
                {"text": "Records", "correct": False},
                {"text": "Text blocks", "correct": False}
            ]
        },
        {
            "prompt": "What is the purpose of the transient keyword?",
            "type": "mcq",
            "choices": [
                {"text": "Prevents field serialization", "correct": True},
                {"text": "Makes field thread-safe", "correct": False},
                {"text": "Makes field immutable", "correct": False},
                {"text": "Marks field as deprecated", "correct": False}
            ]
        },
        {
            "prompt": "What happens when hashCode() returns the same value for all objects?",
            "type": "mcq",
            "choices": [
                {"text": "HashMap becomes a linked list, performance degrades to O(n)", "correct": True},
                {"text": "HashMap throws exception", "correct": False},
                {"text": "HashMap rejects duplicates", "correct": False},
                {"text": "HashMap automatically rehashes", "correct": False}
            ]
        },
        {
            "prompt": "Which are valid ways to create immutable objects in Java?",
            "type": "multi-select",
            "choices": [
                {"text": "Declare class as final", "correct": True},
                {"text": "Make all fields private and final", "correct": True},
                {"text": "Don't provide setter methods", "correct": True},
                {"text": "Use synchronized keyword", "correct": False}
            ]
        },
        {
            "prompt": "What is the diamond problem and how does Java 8 solve it with default methods?",
            "type": "mcq",
            "choices": [
                {"text": "Multiple inheritance ambiguity; requires explicit override", "correct": True},
                {"text": "Java prevents it by disallowing multiple inheritance", "correct": False},
                {"text": "Java automatically resolves it", "correct": False},
                {"text": "It's not a problem in Java", "correct": False}
            ]
        },
        {
            "prompt": "What is the output of: System.out.println(0.1 + 0.2 == 0.3)?",
            "type": "mcq",
            "choices": [
                {"text": "true", "correct": False},
                {"text": "false", "correct": True},
                {"text": "Compilation error", "correct": False},
                {"text": "Runtime error", "correct": False}
            ]
        }
    ],
    
    "Concurrency Deep Dive": [
        {
            "prompt": "What are the consequences of not making the flag variable volatile in a stop mechanism?",
            "type": "mcq",
            "choices": [
                {"text": "Thread may never see the updated value due to caching", "correct": True},
                {"text": "Thread will always see the value", "correct": False},
                {"text": "JVM throws exception", "correct": False},
                {"text": "Thread automatically synchronizes", "correct": False}
            ]
        },
        {
            "prompt": "Which are true about CountDownLatch?",
            "type": "multi-select",
            "choices": [
                {"text": "Can only be used once", "correct": True},
                {"text": "Thread-safe countdown mechanism", "correct": True},
                {"text": "Can be reset and reused", "correct": False},
                {"text": "Blocks until count reaches zero", "correct": True}
            ]
        },
        {
            "prompt": "What is the happens-before relationship in Java Memory Model?",
            "type": "mcq",
            "choices": [
                {"text": "Guarantees visibility of one action to another", "correct": True},
                {"text": "Guarantees execution order", "correct": False},
                {"text": "Synchronization mechanism", "correct": False},
                {"text": "Lock ordering guarantee", "correct": False}
            ]
        },
        {
            "prompt": "What is a spurious wakeup?",
            "type": "mcq",
            "choices": [
                {"text": "Thread wakes from wait() without notify/notifyAll", "correct": True},
                {"text": "Thread wakes with notification", "correct": False},
                {"text": "Thread interruption", "correct": False},
                {"text": "Thread timeout", "correct": False}
            ]
        },
        {
            "prompt": "Which are benefits of using CompletableFuture over Future?",
            "type": "multi-select",
            "choices": [
                {"text": "Supports chaining operations", "correct": True},
                {"text": "Non-blocking completion", "correct": True},
                {"text": "Exception handling with exceptionally()", "correct": True},
                {"text": "Automatic thread creation", "correct": False}
            ]
        },
        {
            "prompt": "What is the difference between synchronized method and ReentrantLock?",
            "type": "mcq",
            "choices": [
                {"text": "ReentrantLock offers tryLock(), timed locks, and interruptible locks", "correct": True},
                {"text": "synchronized is always faster", "correct": False},
                {"text": "ReentrantLock cannot be reentrant", "correct": False},
                {"text": "No significant difference", "correct": False}
            ]
        },
        {
            "prompt": "What is a ForkJoinPool used for?",
            "type": "mcq",
            "choices": [
                {"text": "Divide-and-conquer parallelism using work-stealing algorithm", "correct": True},
                {"text": "Simple thread pooling", "correct": False},
                {"text": "Database connection pooling", "correct": False},
                {"text": "Network connection pooling", "correct": False}
            ]
        },
        {
            "prompt": "Which are true about ThreadLocal?",
            "type": "multi-select",
            "choices": [
                {"text": "Provides thread-confined variables", "correct": True},
                {"text": "Can cause memory leaks if not removed", "correct": True},
                {"text": "Automatically synchronized", "correct": False},
                {"text": "Shared across threads", "correct": False}
            ]
        },
        {
            "prompt": "What is the ABA problem in lock-free programming?",
            "type": "mcq",
            "choices": [
                {"text": "Value changes from A to B and back to A, making CAS think nothing changed", "correct": True},
                {"text": "Deadlock between three threads", "correct": False},
                {"text": "Race condition pattern", "correct": False},
                {"text": "Memory ordering issue", "correct": False}
            ]
        },
        {
            "prompt": "What does StampedLock provide over ReadWriteLock?",
            "type": "mcq",
            "choices": [
                {"text": "Optimistic reading mode without blocking", "correct": True},
                {"text": "Better write performance", "correct": False},
                {"text": "Automatic deadlock detection", "correct": False},
                {"text": "Priority-based locking", "correct": False}
            ]
        }
    ],
    
    "JVM Internals": [
        {
            "prompt": "What are the three main components of HotSpot JVM?",
            "type": "multi-select",
            "choices": [
                {"text": "Class Loader", "correct": True},
                {"text": "Runtime Data Areas", "correct": True},
                {"text": "Execution Engine", "correct": True},
                {"text": "Native Interface Manager", "correct": False}
            ]
        },
        {
            "prompt": "What is the difference between Method Area and Metaspace (Java 8+)?",
            "type": "mcq",
            "choices": [
                {"text": "Metaspace uses native memory, Method Area used heap", "correct": True},
                {"text": "No difference", "correct": False},
                {"text": "Metaspace is smaller", "correct": False},
                {"text": "Method Area is faster", "correct": False}
            ]
        },
        {
            "prompt": "Which GC algorithms are available in modern JVM?",
            "type": "multi-select",
            "choices": [
                {"text": "G1GC", "correct": True},
                {"text": "ZGC", "correct": True},
                {"text": "Shenandoah", "correct": True},
                {"text": "ParallelOldGC", "correct": True}
            ]
        },
        {
            "prompt": "What is a safepoint in JVM?",
            "type": "mcq",
            "choices": [
                {"text": "Point where threads can be stopped for GC or deoptimization", "correct": True},
                {"text": "Synchronization point", "correct": False},
                {"text": "Memory checkpoint", "correct": False},
                {"text": "Thread creation point", "correct": False}
            ]
        },
        {
            "prompt": "What triggers a Full GC in HotSpot?",
            "type": "multi-select",
            "choices": [
                {"text": "Old generation full", "correct": True},
                {"text": "Metaspace full", "correct": True},
                {"text": "System.gc() call", "correct": True},
                {"text": "Thread creation", "correct": False}
            ]
        },
        {
            "prompt": "What is escape analysis?",
            "type": "mcq",
            "choices": [
                {"text": "Optimization determining if object can be allocated on stack", "correct": True},
                {"text": "Security analysis", "correct": False},
                {"text": "Memory leak detection", "correct": False},
                {"text": "Thread escape detection", "correct": False}
            ]
        },
        {
            "prompt": "What are the generations in generational GC?",
            "type": "multi-select",
            "choices": [
                {"text": "Young/Eden", "correct": True},
                {"text": "Survivor spaces", "correct": True},
                {"text": "Old/Tenured", "correct": True},
                {"text": "Permanent", "correct": False}
            ]
        },
        {
            "prompt": "What is JIT compilation?",
            "type": "mcq",
            "choices": [
                {"text": "Compiles hot bytecode to native machine code at runtime", "correct": True},
                {"text": "Ahead-of-time compilation", "correct": False},
                {"text": "Source code compilation", "correct": False},
                {"text": "Bytecode verification", "correct": False}
            ]
        },
        {
            "prompt": "What are the C1 and C2 compilers in HotSpot?",
            "type": "mcq",
            "choices": [
                {"text": "C1 is client compiler (fast compile), C2 is server compiler (optimized code)", "correct": True},
                {"text": "C1 for bytecode, C2 for native", "correct": False},
                {"text": "C1 for Java, C2 for C++", "correct": False},
                {"text": "No difference", "correct": False}
            ]
        },
        {
            "prompt": "What causes Stop-The-World (STW) pauses?",
            "type": "multi-select",
            "choices": [
                {"text": "Full GC", "correct": True},
                {"text": "Young generation GC in some collectors", "correct": True},
                {"text": "Deoptimization", "correct": True},
                {"text": "Thread allocation", "correct": False}
            ]
        }
    ],
    
    "Design Patterns Advanced": [
        {
            "prompt": "What is the key difference between Strategy and State pattern?",
            "type": "mcq",
            "choices": [
                {"text": "Strategy: behavior choice by client; State: internal state transitions", "correct": True},
                {"text": "No difference", "correct": False},
                {"text": "State is for multi-threading", "correct": False},
                {"text": "Strategy is always immutable", "correct": False}
            ]
        },
        {
            "prompt": "Which patterns help solve the object creation complexity?",
            "type": "multi-select",
            "choices": [
                {"text": "Factory Method", "correct": True},
                {"text": "Abstract Factory", "correct": True},
                {"text": "Builder", "correct": True},
                {"text": "Adapter", "correct": False}
            ]
        },
        {
            "prompt": "What problem does the Circuit Breaker pattern solve?",
            "type": "mcq",
            "choices": [
                {"text": "Prevents cascading failures in distributed systems", "correct": True},
                {"text": "Manages electrical circuits", "correct": False},
                {"text": "Controls access to resources", "correct": False},
                {"text": "Pattern matching", "correct": False}
            ]
        },
        {
            "prompt": "When should you use Proxy pattern?",
            "type": "multi-select",
            "choices": [
                {"text": "Lazy initialization", "correct": True},
                {"text": "Access control", "correct": True},
                {"text": "Remote object access", "correct": True},
                {"text": "Object creation", "correct": False}
            ]
        },
        {
            "prompt": "What is the Template Method pattern?",
            "type": "mcq",
            "choices": [
                {"text": "Defines algorithm skeleton, subclasses override steps", "correct": True},
                {"text": "Creates object templates", "correct": False},
                {"text": "Method delegation pattern", "correct": False},
                {"text": "Code generation pattern", "correct": False}
            ]
        },
        {
            "prompt": "Which are structural design patterns?",
            "type": "multi-select",
            "choices": [
                {"text": "Adapter", "correct": True},
                {"text": "Decorator", "correct": True},
                {"text": "Facade", "correct": True},
                {"text": "Observer", "correct": False}
            ]
        },
        {
            "prompt": "What problem does the Flyweight pattern solve?",
            "type": "mcq",
            "choices": [
                {"text": "Reduces memory usage by sharing common state", "correct": True},
                {"text": "Makes objects lighter weight", "correct": False},
                {"text": "Improves object speed", "correct": False},
                {"text": "Simplifies object creation", "correct": False}
            ]
        },
        {
            "prompt": "When is Singleton pattern appropriate?",
            "type": "multi-select",
            "choices": [
                {"text": "Logging service", "correct": True},
                {"text": "Configuration management", "correct": True},
                {"text": "Thread pools", "correct": True},
                {"text": "User session data", "correct": False}
            ]
        },
        {
            "prompt": "What is the Command pattern used for?",
            "type": "mcq",
            "choices": [
                {"text": "Encapsulates request as object enabling undo/redo", "correct": True},
                {"text": "Executes shell commands", "correct": False},
                {"text": "Command-line parsing", "correct": False},
                {"text": "Remote procedure calls", "correct": False}
            ]
        },
        {
            "prompt": "How does the Bridge pattern differ from Adapter?",
            "type": "mcq",
            "choices": [
                {"text": "Bridge: designed upfront to separate abstraction; Adapter: retrofits incompatible interfaces", "correct": True},
                {"text": "No difference", "correct": False},
                {"text": "Bridge is for databases only", "correct": False},
                {"text": "Adapter is always better", "correct": False}
            ]
        }
    ],
    
    "Spring Framework Deep": [
        {
            "prompt": "What is the difference between @Component, @Service, and @Repository?",
            "type": "mcq",
            "choices": [
                {"text": "Semantically different; @Repository adds persistence exception translation", "correct": True},
                {"text": "No difference", "correct": False},
                {"text": "@Service is faster", "correct": False},
                {"text": "@Component is deprecated", "correct": False}
            ]
        },
        {
            "prompt": "Which are valid Spring bean scopes?",
            "type": "multi-select",
            "choices": [
                {"text": "singleton", "correct": True},
                {"text": "prototype", "correct": True},
                {"text": "request", "correct": True},
                {"text": "thread", "correct": False}
            ]
        },
        {
            "prompt": "What happens when a @Transactional method calls another @Transactional method in the same class?",
            "type": "mcq",
            "choices": [
                {"text": "Inner transaction annotation is ignored (proxy limitation)", "correct": True},
                {"text": "Creates nested transaction", "correct": False},
                {"text": "Throws exception", "correct": False},
                {"text": "Both transactions work independently", "correct": False}
            ]
        },
        {
            "prompt": "Which are ways to inject dependencies in Spring?",
            "type": "multi-select",
            "choices": [
                {"text": "Constructor injection", "correct": True},
                {"text": "Setter injection", "correct": True},
                {"text": "Field injection", "correct": True},
                {"text": "Static injection", "correct": False}
            ]
        },
        {
            "prompt": "What is the purpose of @Qualifier annotation?",
            "type": "mcq",
            "choices": [
                {"text": "Resolves ambiguity when multiple beans of same type exist", "correct": True},
                {"text": "Marks bean as qualified", "correct": False},
                {"text": "Defines bean quality level", "correct": False},
                {"text": "Enables bean validation", "correct": False}
            ]
        },
        {
            "prompt": "What are the transaction propagation types in Spring?",
            "type": "multi-select",
            "choices": [
                {"text": "REQUIRED", "correct": True},
                {"text": "REQUIRES_NEW", "correct": True},
                {"text": "NESTED", "correct": True},
                {"text": "MANDATORY", "correct": True}
            ]
        },
        {
            "prompt": "What is the difference between @Controller and @RestController?",
            "type": "mcq",
            "choices": [
                {"text": "@RestController = @Controller + @ResponseBody", "correct": True},
                {"text": "No difference", "correct": False},
                {"text": "@RestController is for REST only", "correct": False},
                {"text": "@Controller is deprecated", "correct": False}
            ]
        },
        {
            "prompt": "Which are valid ways to handle exceptions in Spring MVC?",
            "type": "multi-select",
            "choices": [
                {"text": "@ExceptionHandler", "correct": True},
                {"text": "@ControllerAdvice", "correct": True},
                {"text": "HandlerExceptionResolver", "correct": True},
                {"text": "@ErrorHandler", "correct": False}
            ]
        },
        {
            "prompt": "What is Spring AOP used for?",
            "type": "multi-select",
            "choices": [
                {"text": "Logging", "correct": True},
                {"text": "Transaction management", "correct": True},
                {"text": "Security", "correct": True},
                {"text": "Object creation", "correct": False}
            ]
        },
        {
            "prompt": "What is the @PostConstruct annotation used for?",
            "type": "mcq",
            "choices": [
                {"text": "Lifecycle callback after dependency injection", "correct": True},
                {"text": "POST request handling", "correct": False},
                {"text": "Constructor annotation", "correct": False},
                {"text": "Database post-processing", "correct": False}
            ]
        }
    ]
}

# Generate questions
current_q_id = question_start_id
current_c_id = choice_start_id

for topic, topic_questions in topics.items():
    for q_data in topic_questions:
        question = {
            "id": f"java-q{current_q_id}",
            "deckId": "java-interview",
            "type": q_data["type"],
            "prompt": q_data["prompt"],
            "metadata": "{}",
            "choices": []
        }
        
        for choice in q_data["choices"]:
            question["choices"].append({
                "id": f"java-c{current_c_id}",
                "text": choice["text"],
                "isCorrect": choice["correct"]
            })
            current_c_id += 1
        
        questions_data.append(question)
        current_q_id += 1

# Save to check
print(f"Generated {len(questions_data)} questions")
print(f"Question IDs: java-q{question_start_id} to java-q{current_q_id-1}")
print(f"Choice IDs: java-c{choice_start_id} to java-c{current_c_id-1}")
