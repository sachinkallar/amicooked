import '../../services/scoring/cooked_models.dart';

class QuestionsData {
  static const List<AssessmentQuestion> allQuestions = [
    // 1. Money - Bank balance behavior
    AssessmentQuestion(
      id: 'q1_bank_app',
      text: 'Have you ever checked your bank balance and immediately closed the app?',
      category: CookedCategory.finance,
      memeSubtitle: 'Quantum physics: If you don’t look at it, the money is still there.',
      options: [
        QuestionOption(
          id: 'q1_1',
          text: 'Never. I check my budget daily like an adult.',
          emoji: '😇',
          points: 1,
          category: CookedCategory.finance,
          roastTag: 'frugal_nerd',
        ),
        QuestionOption(
          id: 'q1_2',
          text: 'Once in a while when rent day comes around.',
          emoji: '😐',
          points: 4,
          category: CookedCategory.finance,
        ),
        QuestionOption(
          id: 'q1_3',
          text: 'Regularly. I squint through one eye hoping it changed.',
          emoji: '🫣',
          points: 8,
          category: CookedCategory.finance,
          roastTag: 'balance_coward',
        ),
        QuestionOption(
          id: 'q1_4',
          text: 'I uninstalled the banking app so the overdraft can’t find me.',
          emoji: '💀',
          points: 10,
          category: CookedCategory.finance,
          roastTag: 'financial_fugitive',
        ),
      ],
    ),

    // 2. Money - Days until payday vs balance
    AssessmentQuestion(
      id: 'q2_payday_math',
      text: 'How many days until payday vs how much is left in your account?',
      category: CookedCategory.finance,
      memeSubtitle: 'Currently surviving purely on spite and tap water.',
      options: [
        QuestionOption(
          id: 'q2_1',
          text: '3+ months emergency fund intact. Living comfortably.',
          emoji: '💎',
          points: 0,
          category: CookedCategory.finance,
          roastTag: 'buffett_disciple',
        ),
        QuestionOption(
          id: 'q2_2',
          text: '10 days left, enough for groceries and petrol.',
          emoji: '👌',
          points: 3,
          category: CookedCategory.finance,
        ),
        QuestionOption(
          id: 'q2_3',
          text: '18 days left. Account balance: ₹1,847. Calculations ongoing.',
          emoji: '🧮',
          points: 8,
          category: CookedCategory.finance,
          roastTag: 'eighteen_days_poor',
        ),
        QuestionOption(
          id: 'q2_4',
          text: 'Payday was yesterday and I already have ₹34.50 left.',
          emoji: '📉',
          points: 10,
          category: CookedCategory.finance,
          roastTag: 'instant_broke',
        ),
      ],
    ),

    // 3. Money - Food Delivery Habit
    AssessmentQuestion(
      id: 'q3_food_delivery',
      text: 'Your relationship with Swiggy / Zomato / UberEats is best described as:',
      category: CookedCategory.finance,
      memeSubtitle: '₹40 food + ₹120 delivery + ₹40 platform fee + ₹20 tip = economic collapse.',
      options: [
        QuestionOption(
          id: 'q3_1',
          text: 'I meal-prep every Sunday. Homecooked wholesome meals only.',
          emoji: '🥗',
          points: 1,
          category: CookedCategory.finance,
        ),
        QuestionOption(
          id: 'q3_2',
          text: 'Weekend treat once or twice a week.',
          emoji: '🍕',
          points: 3,
          category: CookedCategory.finance,
        ),
        QuestionOption(
          id: 'q3_3',
          text: 'The delivery driver knows my pet’s name and my emotional state.',
          emoji: '🛵',
          points: 8,
          category: CookedCategory.finance,
          roastTag: 'zomato_gold_addict',
        ),
        QuestionOption(
          id: 'q3_4',
          text: 'I ordered iced coffee and boba from 2 different places in one hour.',
          emoji: '💸',
          points: 10,
          category: CookedCategory.finance,
          roastTag: 'boba_debt',
        ),
      ],
    ),

    // 4. Money - Impulse Buying / EMI
    AssessmentQuestion(
      id: 'q4_impulse_emi',
      text: 'When you see something expensive that you definitely cannot afford:',
      category: CookedCategory.finance,
      memeSubtitle: '“It’s basically an investment in my personal brand.”',
      options: [
        QuestionOption(
          id: 'q4_1',
          text: 'I save up for months and compare prices logically.',
          emoji: '🧘',
          points: 0,
          category: CookedCategory.finance,
        ),
        QuestionOption(
          id: 'q4_2',
          text: 'I add to cart, sleep on it for 48 hours, usually forget it.',
          emoji: '🛒',
          points: 3,
          category: CookedCategory.finance,
        ),
        QuestionOption(
          id: 'q4_3',
          text: '“If I split it into 9 No-Cost EMIs it’s practically free.”',
          emoji: '💳',
          points: 8,
          category: CookedCategory.finance,
          roastTag: 'emi_delusion',
        ),
        QuestionOption(
          id: 'q4_4',
          text: 'Buy now with PayLater, dissociate, cry when the OTP arrives.',
          emoji: '🔥',
          points: 10,
          category: CookedCategory.finance,
          roastTag: 'paylater_victim',
        ),
      ],
    ),

    // 5. Sleep - Actual hours
    AssessmentQuestion(
      id: 'q5_sleep_hours',
      text: 'How many hours of sleep did you get on average this past week?',
      category: CookedCategory.sleep,
      memeSubtitle: 'Your dark circles have developed their own zip code.',
      options: [
        QuestionOption(
          id: 'q5_1',
          text: 'Solid 8+ hours. Consistent circadian rhythm and sunrise walks.',
          emoji: '😇',
          points: 0,
          category: CookedCategory.sleep,
        ),
        QuestionOption(
          id: 'q5_2',
          text: '6 to 7 hours. Decent, standard adult tiredness.',
          emoji: '🙂',
          points: 3,
          category: CookedCategory.sleep,
        ),
        QuestionOption(
          id: 'q5_3',
          text: '4 to 5 hours. Powered by iced Americano and existential anxiety.',
          emoji: '😐',
          points: 7,
          category: CookedCategory.sleep,
          roastTag: 'caffeine_zombie',
        ),
        QuestionOption(
          id: 'q5_4',
          text: 'Sleep is a myth invented by mattress companies. 3 hours max.',
          emoji: '💀',
          points: 10,
          category: CookedCategory.sleep,
          roastTag: 'insomnia_corpse',
        ),
      ],
    ),

    // 6. Sleep - Revenge Bedtime Procrastination
    AssessmentQuestion(
      id: 'q6_bedtime_phone',
      text: 'What happens in bed between 11:30 PM and 2:30 AM?',
      category: CookedCategory.sleep,
      memeSubtitle: '“Just checking one notification” — 3 hours ago.',
      options: [
        QuestionOption(
          id: 'q6_1',
          text: 'Phone is in another room. Asleep by 10:45 PM.',
          emoji: '🌙',
          points: 0,
          category: CookedCategory.sleep,
        ),
        QuestionOption(
          id: 'q6_2',
          text: 'Wind down with a 15-minute podcast and drift off.',
          emoji: '🎧',
          points: 2,
          category: CookedCategory.sleep,
        ),
        QuestionOption(
          id: 'q6_3',
          text: 'Scrolling TikTok/Reels till my phone drops on my face.',
          emoji: '📱',
          points: 8,
          category: CookedCategory.sleep,
          roastTag: 'face_drop_phone',
        ),
        QuestionOption(
          id: 'q6_4',
          text: 'Deep dive into 2011 celebrity drama, carpet cleaning ASMR & Zillow.',
          emoji: '🦉',
          points: 10,
          category: CookedCategory.sleep,
          roastTag: 'asmr_rabbit_hole',
        ),
      ],
    ),

    // 7. Life - Screen Time
    AssessmentQuestion(
      id: 'q7_screen_time',
      text: 'What does your weekly iOS/Android Screen Time report look like?',
      category: CookedCategory.spending,
      memeSubtitle: 'Your retina has absorbed enough blue light to power a lighthouse.',
      options: [
        QuestionOption(
          id: 'q7_1',
          text: 'Under 2.5 hours. Mostly maps, calls, and Kindle.',
          emoji: '🌱',
          points: 0,
          category: CookedCategory.spending,
        ),
        QuestionOption(
          id: 'q7_2',
          text: '3.5 to 5 hours. Average modern worker.',
          emoji: '📊',
          points: 4,
          category: CookedCategory.spending,
        ),
        QuestionOption(
          id: 'q7_3',
          text: '7 to 9 hours. More screen time than awake life.',
          emoji: '👀',
          points: 8,
          category: CookedCategory.spending,
          roastTag: 'cyborg_scroller',
        ),
        QuestionOption(
          id: 'q7_4',
          text: '11+ hours. I turned off the weekly report notification out of shame.',
          emoji: '☢️',
          points: 10,
          category: CookedCategory.spending,
          roastTag: 'screen_time_censored',
        ),
      ],
    ),

    // 8. Life - Unread Messages & Notifications
    AssessmentQuestion(
      id: 'q8_unread_badges',
      text: 'How many unread notifications / emails / WhatsApp chats right now?',
      category: CookedCategory.lifestyle,
      memeSubtitle: 'Inbox Zero vs Inbox Ten Thousand.',
      options: [
        QuestionOption(
          id: 'q8_1',
          text: 'Zero. Red badge dots give me hives. Everything archived.',
          emoji: '🧼',
          points: 0,
          category: CookedCategory.lifestyle,
        ),
        QuestionOption(
          id: 'q8_2',
          text: 'A dozen unread promo emails. Personal chats answered.',
          emoji: '📨',
          points: 3,
          category: CookedCategory.lifestyle,
        ),
        QuestionOption(
          id: 'q8_3',
          text: '347 unread WhatsApp chats. I reply in my head and forget for 3 weeks.',
          emoji: '👻',
          points: 8,
          category: CookedCategory.lifestyle,
          roastTag: 'mental_replier',
        ),
        QuestionOption(
          id: 'q8_4',
          text: '99,999+ unread. Red badges are part of my phone wallpaper now.',
          emoji: '🔴',
          points: 10,
          category: CookedCategory.lifestyle,
          roastTag: 'notification_hoarder',
        ),
      ],
    ),

    // 9. Life - "I'll start tomorrow" frequency
    AssessmentQuestion(
      id: 'q9_procrastination',
      text: 'How often do you say “I’ll start from Monday / tomorrow”?',
      category: CookedCategory.lifestyle,
      memeSubtitle: 'Monday is a mythological creature that never arrives.',
      options: [
        QuestionOption(
          id: 'q9_1',
          text: 'Rarely. If something needs doing, I tackle it immediately.',
          emoji: '⚡',
          points: 0,
          category: CookedCategory.lifestyle,
        ),
        QuestionOption(
          id: 'q9_2',
          text: 'Sometimes for the gym, but work gets done.',
          emoji: '🏋️',
          points: 4,
          category: CookedCategory.lifestyle,
        ),
        QuestionOption(
          id: 'q9_3',
          text: 'Every Sunday night without fail. Repeat cycle indefinitely.',
          emoji: '🔄',
          points: 7,
          category: CookedCategory.lifestyle,
          roastTag: 'monday_delusion',
        ),
        QuestionOption(
          id: 'q9_4',
          text: 'I’ve postponed starting tomorrow to the next fiscal year.',
          emoji: '🗓️',
          points: 10,
          category: CookedCategory.lifestyle,
          roastTag: 'eternal_delayer',
        ),
      ],
    ),

    // 10. Career - Burnout & Morning feeling
    AssessmentQuestion(
      id: 'q10_morning_work',
      text: 'Your first conscious thought when your 7:30 AM alarm rings on a weekday:',
      category: CookedCategory.career,
      memeSubtitle: 'Staring at the ceiling questioning your life choices for 20 minutes.',
      options: [
        QuestionOption(
          id: 'q10_1',
          text: '“Another productive day ahead! Let’s crush some goals!”',
          emoji: '☀️',
          points: 0,
          category: CookedCategory.career,
          roastTag: 'linkedin_influencer',
        ),
        QuestionOption(
          id: 'q10_2',
          text: '“Time to get up and make that bread. Coffee first.”',
          emoji: '☕',
          points: 3,
          category: CookedCategory.career,
        ),
        QuestionOption(
          id: 'q10_3',
          text: '“If I break a toe, do I get 3 days sick leave?”',
          emoji: '🩹',
          points: 8,
          category: CookedCategory.career,
          roastTag: 'medical_excuse_inventor',
        ),
        QuestionOption(
          id: 'q10_4',
          text: 'Stare at ceiling, ponder selling goat cheese in the Himalayas.',
          emoji: '🐐',
          points: 10,
          category: CookedCategory.career,
          roastTag: 'himalayan_monk_dreamer',
        ),
      ],
    ),

    // 11. Career - Five-year plan
    AssessmentQuestion(
      id: 'q11_five_year_plan',
      text: 'Where do you see yourself in 5 years?',
      category: CookedCategory.career,
      memeSubtitle: 'Recruiter’s favorite question, your worst nightmare.',
      options: [
        QuestionOption(
          id: 'q11_1',
          text: 'Principal Lead / Partner with diversified equity & real estate.',
          emoji: '📈',
          points: 0,
          category: CookedCategory.career,
        ),
        QuestionOption(
          id: 'q11_2',
          text: 'A title promotion and at least a 35% salary bump.',
          emoji: '🎯',
          points: 3,
          category: CookedCategory.career,
        ),
        QuestionOption(
          id: 'q11_3',
          text: 'I literally don’t know what I’m having for lunch today.',
          emoji: '🤷',
          points: 7,
          category: CookedCategory.career,
          roastTag: 'lunch_confused',
        ),
        QuestionOption(
          id: 'q11_4',
          text: 'Surviving the AI takeover and hopefully not in debtors’ prison.',
          emoji: '🤖',
          points: 10,
          category: CookedCategory.career,
          roastTag: 'ai_doomer',
        ),
      ],
    ),

    // 12. Career - Résumé updating frequency
    AssessmentQuestion(
      id: 'q12_resume_state',
      text: 'When was the last time you updated your CV / LinkedIn profile?',
      category: CookedCategory.career,
      memeSubtitle: '“Proficient in Microsoft Office 2007 and Macromedia Flash.”',
      options: [
        QuestionOption(
          id: 'q12_1',
          text: 'Last month. Regularly networking and keeping metrics fresh.',
          emoji: '👔',
          points: 0,
          category: CookedCategory.career,
        ),
        QuestionOption(
          id: 'q12_2',
          text: 'About 6–12 months ago when I got my current role.',
          emoji: '📁',
          points: 4,
          category: CookedCategory.career,
        ),
        QuestionOption(
          id: 'q12_3',
          text: 'Only during explosive 4:00 PM mental breakdowns on a Tuesday.',
          emoji: '💥',
          points: 8,
          category: CookedCategory.career,
          roastTag: 'rage_job_hunter',
        ),
        QuestionOption(
          id: 'q12_4',
          text: 'My resume is an unsaved Word 2013 doc somewhere on an old laptop.',
          emoji: '💾',
          points: 10,
          category: CookedCategory.career,
          roastTag: 'stone_age_cv',
        ),
      ],
    ),

    // 13. Questionable Decisions - The Midnight Online Cart
    AssessmentQuestion(
      id: 'q13_midnight_shopping',
      text: 'What is the strangest item you have purchased while emotionally vulnerable?',
      category: CookedCategory.spending,
      memeSubtitle: 'Dopamine has a 1-click checkout button.',
      options: [
        QuestionOption(
          id: 'q13_1',
          text: 'Nothing. I don’t buy things when emotional.',
          emoji: '🛡️',
          points: 0,
          category: CookedCategory.spending,
        ),
        QuestionOption(
          id: 'q13_2',
          text: 'A moderately overpriced scented candle or fancy notebook.',
          emoji: '🕯️',
          points: 3,
          category: CookedCategory.spending,
        ),
        QuestionOption(
          id: 'q13_3',
          text: 'A ₹4,000 posture corrector / gym gear I used for exactly 11 minutes.',
          emoji: '📦',
          points: 8,
          category: CookedCategory.spending,
          roastTag: 'posture_clown',
        ),
        QuestionOption(
          id: 'q13_4',
          text: 'An artisanal Japanese sourdough kit or crypto meme token at 3:15 AM.',
          emoji: '🚀',
          points: 10,
          category: CookedCategory.spending,
          roastTag: 'crypto_sourdough_king',
        ),
      ],
    ),

    // 14. Questionable Decisions - Meeting / Social Battery
    AssessmentQuestion(
      id: 'q14_social_battery',
      text: 'When a friend calls unexpectedly without texting first:',
      category: CookedCategory.lifestyle,
      memeSubtitle: 'A ringing phone is essentially a threat.',
      options: [
        QuestionOption(
          id: 'q14_1',
          text: 'Pick up cheerfully! I love talking to friends!',
          emoji: '📞',
          points: 0,
          category: CookedCategory.lifestyle,
        ),
        QuestionOption(
          id: 'q14_2',
          text: 'Pick up if I’m free, or text back in a few minutes.',
          emoji: '💬',
          points: 2,
          category: CookedCategory.lifestyle,
        ),
        QuestionOption(
          id: 'q14_3',
          text: 'Stare at the ringing screen in mute terror until it stops, then text “What’s up?”.',
          emoji: '📴',
          points: 8,
          category: CookedCategory.lifestyle,
          roastTag: 'call_phobic',
        ),
        QuestionOption(
          id: 'q14_4',
          text: 'Turn on Airplane mode and tell them 3 days later my phone had a virus.',
          emoji: '✈️',
          points: 10,
          category: CookedCategory.lifestyle,
          roastTag: 'airplane_mode_recluse',
        ),
      ],
    ),

    // 15. The Grand Finale - General Delusion Level
    AssessmentQuestion(
      id: 'q15_final_vibe',
      text: 'Overall, how would you describe your current trajectory in life?',
      category: CookedCategory.lifestyle,
      memeSubtitle: 'Be honest. The algorithm already knows the truth.',
      options: [
        QuestionOption(
          id: 'q15_1',
          text: 'Thriving, hydrated, compound interest compounding.',
          emoji: '🥗',
          points: 0,
          category: CookedCategory.lifestyle,
          roastTag: 'annoyingly_successful',
        ),
        QuestionOption(
          id: 'q15_2',
          text: 'Surviving with mild bumps, but fundamentally on track.',
          emoji: '⛵',
          points: 3,
          category: CookedCategory.lifestyle,
        ),
        QuestionOption(
          id: 'q15_3',
          text: 'The engine is on fire, but the playlist is absolute fire.',
          emoji: '🎶🔥',
          points: 8,
          category: CookedCategory.lifestyle,
          roastTag: 'vibing_in_flames',
        ),
        QuestionOption(
          id: 'q15_4',
          text: 'Speedrunning bankruptcy and mental collapse. Let’s see the damage.',
          emoji: '🏎️💥',
          points: 10,
          category: CookedCategory.lifestyle,
          roastTag: 'speedrunning_ruin',
        ),
      ],
    ),
  ];
}
