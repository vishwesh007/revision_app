import json

with open('java_interview_questions.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

# Find and fix problematic questions
problems = []

for i, q in enumerate(data['questions'], 1):
    if q['type'] == 'multi-select':
        correct_count = sum(1 for c in q['choices'] if c['isCorrect'])
        if correct_count < 2:
            problems.append((i, q['id'], q['prompt'], correct_count))
            print(f"\nProblem found at Q{i} ({q['id']})")
            print(f"Prompt: {q['prompt']}")
            print(f"Correct answers: {correct_count}")
            print("Choices:")
            for c in q['choices']:
                print(f"  [{c['isCorrect']}] {c['text']}")
            
            # Fix: Make it an MCQ instead
            print("\n  FIX: Converting to MCQ (single answer)")
            q['type'] = 'mcq'

if problems:
    print(f"\n\nFixed {len(problems)} problematic multi-select questions by converting to MCQ")
    
    # Save fixed data
    with open('java_interview_questions.json', 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
    
    print("✅ File updated and saved")
else:
    print("No problems found!")
