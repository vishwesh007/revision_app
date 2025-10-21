# Java Interview Questions Generation Prompt

## Overview
Generate professional Java interview questions for experienced developers (4+ years) in JSON format compatible with the Revision Buddy app.

## Target Audience
- 4+ years of Java development experience
- Full-stack Java developers
- Senior backend developers
- Java architects

## Question Distribution
- **70% MCQ (Multiple Choice Questions)**: Single correct answer
- **30% MSQ (Multiple Select Questions)**: Multiple correct answers
- Mix of theoretical and practical questions
- Include edge cases and tricky scenarios

## Required JSON Structure
```json
{
  "decks": [
    {
      "id": "java-interview",
      "title": "Java Interview Questions",
      "description": "Advanced Java interview questions for experienced developers",
      "createdAt": "2025-10-21T00:00:00.000Z"
    }
  ],
  "questions": [
    {
      "id": "java-q{N}",
      "deckId": "java-interview",
      "type": "mcq", // or "multi-select"
      "prompt": "Question text here",
      "metadata": "{}",
      "choices": [
        {"id": "java-c{M}", "text": "Choice text", "isCorrect": true/false},
        // 3 more choices for MCQ, variable for MSQ
      ]
    }
  ]
}
```

## ID Numbering Convention
- Questions: java-q101, java-q102, etc. (continue from last used number)
- Choices: java-c401, java-c402, etc. (continue from last used number)
- Ensure unique IDs across all questions

## Core Topics to Cover (Advanced Level)

### 1. Core Java
- Collections Framework (HashMap, ConcurrentHashMap, etc.)
- Concurrency (volatile, synchronized, locks, atomic operations)
- JVM internals (memory management, GC, class loading)
- Generics (wildcards, type erasure, bounded types)
- Java 8+ features (Streams, Optional, CompletableFuture, lambdas)

### 2. Spring Framework
- Core annotations (@Component, @Bean, @Autowired, @Qualifier)
- Spring Boot (auto-configuration, starters, actuators)
- Spring MVC (controllers, REST, validation)
- Spring Data JPA (repositories, queries, auditing)
- Spring Security (authentication, authorization, OAuth)
- Spring AOP (advice, pointcuts, aspects)
- Spring Cloud (config, discovery, circuit breakers)

### 3. JPA/Hibernate
- Entity relationships (@OneToOne, @OneToMany, @ManyToMany)
- Fetch strategies (LAZY vs EAGER)
- Caching (first-level, second-level)
- Query methods (@Query, JPQL, Criteria API)
- Transaction management
- Performance optimization (N+1 problem, batching)

### 4. Database & Persistence
- SQL optimization
- Connection pooling
- Database transactions (ACID, isolation levels)
- ORM best practices
- Database migration tools

### 5. Microservices Architecture
- Service decomposition
- API design (REST, GraphQL)
- Inter-service communication
- Distributed systems concepts
- Containerization (Docker)
- Orchestration (Kubernetes)

### 6. Testing
- Unit testing (JUnit, Mockito, TestNG)
- Integration testing
- TDD/BDD approaches
- Test coverage and quality metrics

### 7. Performance & Optimization
- JVM tuning parameters
- Memory management
- Profiling tools
- Caching strategies
- Database optimization

### 8. Security
- Authentication & authorization
- OWASP top vulnerabilities
- Encryption & hashing
- Secure coding practices
- Spring Security implementation

### 9. DevOps & Tools
- Build tools (Maven, Gradle)
- CI/CD pipelines
- Containerization & orchestration
- Monitoring & logging
- Code quality tools

### 10. Design Patterns & Architecture
- SOLID principles
- Gang of Four patterns
- Enterprise patterns
- Clean architecture
- Domain-driven design

## Question Quality Guidelines

### Difficulty Levels
- **Basic**: Syntax, basic concepts (avoid these)
- **Intermediate**: Framework usage, common patterns
- **Advanced**: Edge cases, performance, architecture decisions
- **Expert**: Deep internals, optimization, troubleshooting

### Question Characteristics
- **Clear and concise**: No ambiguity in wording
- **Single focus**: Test one concept at a time
- **Real-world relevance**: Practical scenarios
- **Tricky but fair**: Avoid trick questions that rely on syntax errors
- **Updated knowledge**: Include modern Java features and frameworks

### Answer Choices
- **MCQ**: 4 choices, exactly 1 correct
- **MSQ**: 4-5 choices, 2-3 correct (clearly indicate multiple correct)
- **Distractors**: Plausible but incorrect alternatives
- **Length**: Keep choices similar in length
- **No absolutes**: Avoid "always" or "never" unless truly accurate

## Example Questions

### MCQ Example
```json
{
  "id": "java-q1",
  "deckId": "java-interview",
  "type": "mcq",
  "prompt": "What is the primary difference between HashMap and ConcurrentHashMap?",
  "metadata": "{}",
  "choices": [
    {"id": "java-c1", "text": "HashMap is synchronized, ConcurrentHashMap is not", "isCorrect": false},
    {"id": "java-c2", "text": "ConcurrentHashMap allows concurrent modifications without external synchronization", "isCorrect": true},
    {"id": "java-c3", "text": "HashMap supports null keys, ConcurrentHashMap does not", "isCorrect": false},
    {"id": "java-c4", "text": "ConcurrentHashMap uses a single lock, HashMap uses multiple", "isCorrect": false}
  ]
}
```

### MSQ Example
```json
{
  "id": "java-q2",
  "deckId": "java-interview",
  "type": "multi-select",
  "prompt": "Which of the following are true about Java's volatile keyword? (Select all that apply)",
  "metadata": "{}",
  "choices": [
    {"id": "java-c5", "text": "Guarantees atomicity of compound operations", "isCorrect": false},
    {"id": "java-c6", "text": "Prevents instruction reordering around the variable", "isCorrect": true},
    {"id": "java-c7", "text": "Ensures visibility of changes across threads", "isCorrect": true},
    {"id": "java-c8", "text": "Provides mutual exclusion like synchronized", "isCorrect": false}
  ]
}
```

## Generation Process

1. **Plan topics**: Select 10-15 questions from different topic areas
2. **Research accuracy**: Ensure technical accuracy and current best practices
3. **Write questions**: Clear, professional language
4. **Create choices**: Mix correct/incorrect answers appropriately
5. **Review and test**: Verify answers are correct and unambiguous
6. **Format JSON**: Follow exact structure and ID conventions

## Quality Checklist

- [ ] All questions are 4+ year experience level
- [ ] Mix of MCQ (70%) and MSQ (30%)
- [ ] Topics cover full Java ecosystem
- [ ] Questions are practical and relevant
- [ ] Answers are technically accurate
- [ ] JSON structure is valid
- [ ] IDs are unique and follow convention
- [ ] No duplicate questions or choices

## File Naming Convention
- Use descriptive names: `java_interview_questions.json`
- Include version or date if needed: `java_interview_questions_v2.json`

## Validation Steps
1. JSON syntax validation
2. ID uniqueness check
3. Answer correctness verification
4. Question clarity review
5. Topic balance assessment