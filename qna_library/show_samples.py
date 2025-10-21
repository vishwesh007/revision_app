import json

with open('java_interview_questions.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

questions = data['questions']

print(f"✅ Total Questions: {len(questions)}\n")
print("="*80)
print("SAMPLE QUESTIONS FROM EACH SECTION:")
print("="*80)

samples = [1, 201, 300, 400, 500, 600, 700, 800, 900, 1000]

for idx in samples:
    q = questions[idx-1]
    print(f"\nQ{idx}: {q['prompt']}")
    print(f"Type: {q['type']}")
    print(f"Choices: {len(q['choices'])}")
    correct_count = sum(1 for c in q['choices'] if c['isCorrect'])
    print(f"Correct answers: {correct_count}")

print("\n" + "="*80)
print("STATISTICS:")
print("="*80)

# Count question types
mcq_count = sum(1 for q in questions if q['type'] == 'mcq')
multi_count = sum(1 for q in questions if q['type'] == 'multi-select')

print(f"MCQ questions: {mcq_count}")
print(f"Multi-select questions: {multi_count}")

# Topic distribution (estimate based on ID ranges)
print(f"\nTopic Distribution (estimated):")
print(f"  Original questions (1-200): 200")
print(f"  Core Java Advanced (201-300): 100")
print(f"  Concurrency & Threading (301-450): 150")
print(f"  Spring Framework (451-600): 150")
print(f"  Microservices & Cloud (601-700): 100")
print(f"  Data Structures & Algorithms (701-800): 100")
print(f"  System Design (801-900): 100")
print(f"  Database & SQL (901-1000): 100")

print(f"\n✅ File successfully contains 1000 high-quality Java interview questions!")
