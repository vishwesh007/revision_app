import json

with open('java_interview_questions.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

print(f"Total questions: {len(data['questions'])}")
print(f"First question: {data['questions'][0]['id']}")
print(f"Last question: {data['questions'][-1]['id']}")
print(f"First new question (201): {data['questions'][200]['id']}")

# Trim to exactly 1000 if needed
if len(data['questions']) > 1000:
    print(f"\nTrimming from {len(data['questions'])} to 1000 questions...")
    data['questions'] = data['questions'][:1000]
    
    with open('java_interview_questions.json', 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
    
    print("✅ Trimmed to exactly 1000 questions")
    print(f"New last question: {data['questions'][-1]['id']}")
else:
    print("\n✅ Already at target count!")
