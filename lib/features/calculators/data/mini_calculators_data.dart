import 'package:intl/intl.dart';
import '../models/mini_calculator_model.dart';

class MiniCalculatorsData {
  static final NumberFormat inrFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static final List<MiniCalculatorDef> all = [
    // 1. Can I Afford This?
    MiniCalculatorDef(
      slug: 'can-i-afford-this',
      title: 'Can I Afford This?',
      emoji: '💰',
      subtitle: 'Input price vs bank balance vs days until salary. Brace for impact.',
      category: 'Finance',
      fields: const [
        MiniCalculatorField(
          key: 'item_price',
          label: 'Item Price (₹)',
          type: CalculatorFieldType.currency,
          defaultValue: 4999,
          helperText: 'That thing you have in your cart right now.',
        ),
        MiniCalculatorField(
          key: 'bank_balance',
          label: 'Current Bank Balance (₹)',
          type: CalculatorFieldType.currency,
          defaultValue: 12500,
          helperText: 'Check without crying.',
        ),
        MiniCalculatorField(
          key: 'days_until_payday',
          label: 'Days Until Next Payday',
          type: CalculatorFieldType.number,
          defaultValue: 16,
          helperText: 'Calendar days left of survival.',
        ),
        MiniCalculatorField(
          key: 'monthly_bills',
          label: 'Unpaid Rent / Bills Remaining (₹)',
          type: CalculatorFieldType.currency,
          defaultValue: 5000,
          helperText: 'Things that landlord or electricity board will demand.',
        ),
      ],
      compute: (inputs) {
        final price = (inputs['item_price'] as num?)?.toDouble() ?? 0;
        final balance = (inputs['bank_balance'] as num?)?.toDouble() ?? 0;
        final days = (inputs['days_until_payday'] as num?)?.toDouble() ?? 1;
        final bills = (inputs['monthly_bills'] as num?)?.toDouble() ?? 0;

        final remainingCash = balance - bills - price;
        final dailyBudget = days > 0 ? remainingCash / days : 0;

        int score;
        String title;
        String emoji;
        String desc;

        if (remainingCash < 0) {
          score = 98;
          title = 'CALL THE EMBASSY 💀';
          emoji = '🚨';
          desc = 'Buying this will leave you at ${inrFormat.format(remainingCash)}. You literally cannot afford air, let alone this.';
        } else if (dailyBudget < 150) {
          score = 85;
          title = 'ICE CUBES FOR DINNER';
          emoji = '🧊';
          desc = 'You will have ${inrFormat.format(dailyBudget)}/day left to survive for $days days. Hope you like boiled water and phototropism.';
        } else if (dailyBudget < 500) {
          score = 55;
          title = 'MILDLY DELUSIONAL';
          emoji = '🥪';
          desc = 'You can afford it if you cancel all social outings and eat lentils until payday arrives.';
        } else {
          score = 15;
          title = 'SURPRISINGLY AFFORDABLE';
          emoji = '💎';
          desc = 'You actually have sufficient runway. Buy it before inflation eats the money anyway.';
        }

        return MiniCalculatorResult(
          cookedScore: score,
          verdictTitle: title,
          verdictEmoji: emoji,
          verdictDescription: desc,
          detailedBreakdown:
              'Remaining Balance: ${inrFormat.format(remainingCash)} • Daily Survival Budget: ${inrFormat.format(dailyBudget.clamp(0, 999999))}/day',
          tips: [
            'Wait 48 hours. If you still want it, check bank balance again.',
            'Never buy luxuries on days 10–28 of the month.',
            'Remember: Having money to buy something ≠ being able to afford it.',
          ],
        );
      },
    ),

    // 2. Can I Afford Food Delivery?
    MiniCalculatorDef(
      slug: 'can-i-afford-food-delivery',
      title: 'Can I Afford Food Delivery?',
      emoji: '🍔',
      subtitle: '₹80 burger + ₹140 hidden fees = economic ruin.',
      category: 'Finance',
      fields: const [
        MiniCalculatorField(
          key: 'food_price',
          label: 'Meal Base Price (₹)',
          type: CalculatorFieldType.currency,
          defaultValue: 280,
        ),
        MiniCalculatorField(
          key: 'delivery_fees',
          label: 'Platform + Delivery + Rain + Surge Fees (₹)',
          type: CalculatorFieldType.currency,
          defaultValue: 95,
        ),
        MiniCalculatorField(
          key: 'fridge_groceries',
          label: 'Do you have edible groceries in fridge right now?',
          type: CalculatorFieldType.dropdown,
          defaultString: 'yes_lazy',
          dropdownOptions: [
            DropdownOption(label: 'Yes, but I am too lazy to cook', value: 'yes_lazy'),
            DropdownOption(label: 'Yes, but it takes 15 minutes of effort', value: 'yes_effort'),
            DropdownOption(label: 'No, literally empty water bottles only', value: 'empty'),
          ],
        ),
      ],
      compute: (inputs) {
        final foodPrice = (inputs['food_price'] as num?)?.toDouble() ?? 250;
        final fees = (inputs['delivery_fees'] as num?)?.toDouble() ?? 80;
        final fridge = inputs['fridge_groceries'] as String? ?? 'yes_lazy';

        final feePercentage = ((fees / foodPrice) * 100).round();
        int score = feePercentage > 35 ? 75 : 45;
        if (fridge == 'yes_lazy') score += 20;

        score = score.clamp(0, 100);

        return MiniCalculatorResult(
          cookedScore: score,
          verdictTitle: score > 70 ? 'COOKED BY CONVENIENCE' : 'JUSTIFIABLE FUEL',
          verdictEmoji: score > 70 ? '🛵💸' : '🍱',
          verdictDescription:
              'You are paying a $feePercentage% tax just to not stand up from your couch. Total order: ${inrFormat.format(foodPrice + fees)}.',
          detailedBreakdown:
              'Delivery markup: $feePercentage% • Guilt index: $score% Cooked',
          tips: [
            'Go boil the eggs sitting in your fridge.',
            'That delivery tip was higher than your savings interest rate this quarter.',
          ],
        );
      },
    ),

    // 3. Am I Actually a Senior Developer?
    MiniCalculatorDef(
      slug: 'am-i-actually-a-senior-developer',
      title: 'Am I Actually a Senior Developer?',
      emoji: '💻',
      subtitle: 'Or just 6 years of Googling "how to center a div"?',
      category: 'Career',
      fields: const [
        MiniCalculatorField(
          key: 'yoe',
          label: 'Years of Experience',
          type: CalculatorFieldType.number,
          defaultValue: 4,
        ),
        MiniCalculatorField(
          key: 'prod_incidents',
          label: 'Production Incidents Caused This Year',
          type: CalculatorFieldType.number,
          defaultValue: 2,
        ),
        MiniCalculatorField(
          key: 'browser_tabs',
          label: 'Number of Open Chrome Tabs Right Now',
          type: CalculatorFieldType.number,
          defaultValue: 43,
        ),
      ],
      compute: (inputs) {
        final yoe = (inputs['yoe'] as num?)?.toDouble() ?? 3;
        final incidents = (inputs['prod_incidents'] as num?)?.toDouble() ?? 1;
        final tabs = (inputs['browser_tabs'] as num?)?.toDouble() ?? 30;

        int score = (100 - (yoe * 12) + (incidents * 15) + (tabs * 0.4)).round().clamp(0, 100);

        String title;
        String desc;

        if (score < 30) {
          title = 'ACTUAL 10X WIZARD';
          desc = 'You write clean architectures and sleep at night. How did you get here?';
        } else if (score < 65) {
          title = 'IMPOSTER SYNDROME CHIEF';
          desc = 'You know enough to be dangerous, and you know how to blame cache invalidation.';
        } else {
          title = 'CERTIFIED STACKOVERFLOW CLOWN';
          desc = 'One git push away from wiping the prod Postgres instance. Pray before committing.';
        }

        return MiniCalculatorResult(
          cookedScore: score,
          verdictTitle: title,
          verdictEmoji: '💾💀',
          verdictDescription: desc,
          detailedBreakdown: 'Imposter Index: $score% • Recommended Action: Close $tabs tabs',
          tips: [
            'Say "it depends on trade-offs" in your next meeting to sound 50% more senior.',
            'Always test migrations locally first.',
          ],
        );
      },
    ),

    // 4. Sleep Cooked Score
    MiniCalculatorDef(
      slug: 'sleep-cooked-score',
      title: 'Sleep Cooked Score',
      emoji: '😴',
      subtitle: 'Measure your sleep debt before your nervous system shuts down.',
      category: 'Lifestyle',
      fields: const [
        MiniCalculatorField(
          key: 'sleep_hours',
          label: 'Average Hours of Sleep This Week',
          type: CalculatorFieldType.slider,
          min: 2,
          max: 10,
          defaultValue: 5,
        ),
        MiniCalculatorField(
          key: 'bed_phone_min',
          label: 'Minutes Scrolling Phone in Bed Before Sleeping',
          type: CalculatorFieldType.number,
          defaultValue: 75,
        ),
        MiniCalculatorField(
          key: 'caffeine_cups',
          label: 'Cups of Coffee / Chai / Energy Drinks per Day',
          type: CalculatorFieldType.number,
          defaultValue: 3,
        ),
      ],
      compute: (inputs) {
        final sleep = (inputs['sleep_hours'] as num?)?.toDouble() ?? 5;
        final phoneMin = (inputs['bed_phone_min'] as num?)?.toDouble() ?? 60;
        final caffeine = (inputs['caffeine_cups'] as num?)?.toDouble() ?? 2;

        final sleepDeficit = (8 - sleep).clamp(0, 6);
        final score = ((sleepDeficit * 12) + (phoneMin * 0.3) + (caffeine * 6)).round().clamp(0, 100);

        return MiniCalculatorResult(
          cookedScore: score,
          verdictTitle: score > 75 ? 'WALKING CORPSE' : 'RUNNING ON FUMES',
          verdictEmoji: score > 75 ? '🧟' : '☕',
          verdictDescription:
              'Weekly sleep debt: ${(sleepDeficit * 7).round()} hours. Your circadian rhythm is crying.',
          detailedBreakdown: 'Sleep Debt: ${(sleepDeficit * 7).round()} hrs/week • Blue Light Poisoning: High',
          tips: [
            'Charge your phone in the kitchen tonight.',
            'No caffeine after 3 PM if you value your sanity.',
          ],
        );
      },
    ),

    // 5. Do I Actually Need This?
    MiniCalculatorDef(
      slug: 'do-i-actually-need-this',
      title: 'Do I Actually Need This?',
      emoji: '🛒',
      subtitle: 'The 3-minute reality check for midnight retail therapy.',
      category: 'Finance',
      fields: const [
        MiniCalculatorField(
          key: 'item_name',
          label: 'What is the item?',
          type: CalculatorFieldType.dropdown,
          defaultString: 'gadget',
          dropdownOptions: [
            DropdownOption(label: 'Tech gadget / accessory', value: 'gadget'),
            DropdownOption(label: 'Clothing / Shoes', value: 'clothes'),
            DropdownOption(label: 'Kitchen appliance / Home gym', value: 'lifestyle'),
            DropdownOption(label: 'Subscription or course', value: 'course'),
          ],
        ),
        MiniCalculatorField(
          key: 'item_cost',
          label: 'Price (₹)',
          type: CalculatorFieldType.currency,
          defaultValue: 3499,
        ),
        MiniCalculatorField(
          key: 'emotion',
          label: 'Why are you buying it right now?',
          type: CalculatorFieldType.dropdown,
          defaultString: 'bored',
          dropdownOptions: [
            DropdownOption(label: 'Bored / Stressed after a long day', value: 'bored'),
            DropdownOption(label: 'It will completely transform my life', value: 'delusion'),
            DropdownOption(label: 'Old one broke and I literally need it', value: 'broken'),
          ],
        ),
      ],
      compute: (inputs) {
        final emotion = inputs['emotion'] as String? ?? 'bored';
        final cost = (inputs['item_cost'] as num?)?.toDouble() ?? 3000;

        int score = 40;
        if (emotion == 'bored') score = 88;
        if (emotion == 'delusion') score = 92;
        if (emotion == 'broken') score = 20;

        return MiniCalculatorResult(
          cookedScore: score,
          verdictTitle: score > 70 ? 'DOPAMINE TRAP 💀' : 'ACTUALLY ESSENTIAL',
          verdictEmoji: score > 70 ? '🛍️🗑️' : '✅',
          verdictDescription: score > 70
              ? 'You are attempting to purchase happiness with ${inrFormat.format(cost)}. It will sit in a drawer by next Thursday.'
              : 'Proceed with checkout. This one passes the sanity filter.',
          detailedBreakdown: 'Delusion Factor: $score% • Shelf-life: 4 days before buyer remorse',
          tips: [
            'Add it to wishlist and revisit in 7 days.',
            'Ask: "Would I buy this if it was full price and cash only?"',
          ],
        );
      },
    ),

    // 6. Salary-to-Poverty
    MiniCalculatorDef(
      slug: 'salary-to-poverty',
      title: 'Salary-to-Poverty Speedrun',
      emoji: '💸',
      subtitle: 'Calculate your exact burn rate and the date of total liquidity collapse.',
      category: 'Finance',
      fields: const [
        MiniCalculatorField(
          key: 'monthly_salary',
          label: 'Monthly Take-Home Salary (₹)',
          type: CalculatorFieldType.currency,
          defaultValue: 65000,
        ),
        MiniCalculatorField(
          key: 'current_balance',
          label: 'Money Left Right Now (₹)',
          type: CalculatorFieldType.currency,
          defaultValue: 8400,
        ),
        MiniCalculatorField(
          key: 'day_of_month',
          label: 'Today’s Date (1 to 31)',
          type: CalculatorFieldType.slider,
          min: 1,
          max: 31,
          defaultValue: 18,
        ),
      ],
      compute: (inputs) {
        final salary = (inputs['monthly_salary'] as num?)?.toDouble() ?? 50000;
        final left = (inputs['current_balance'] as num?)?.toDouble() ?? 5000;
        final date = (inputs['day_of_month'] as num?)?.toDouble() ?? 15;

        final spent = salary - left;
        final daysPassed = date.clamp(1, 30);
        final dailyBurn = spent / daysPassed;
        final daysLeft = 30 - date;
        final runway = dailyBurn > 0 ? left / dailyBurn : 999;

        final score = ((1 - (runway / (daysLeft > 0 ? daysLeft : 1))) * 100).round().clamp(0, 100);

        return MiniCalculatorResult(
          cookedScore: score,
          verdictTitle: runway < daysLeft ? 'BANKRUPTCY IMMINENT' : 'STABLE RUNWAY',
          verdictEmoji: runway < daysLeft ? '📉🔥' : '📈',
          verdictDescription:
              'At your current burn rate of ${inrFormat.format(dailyBurn)}/day, your cash runs out in ${runway.toStringAsFixed(1)} days ($daysLeft days until next payday).',
          detailedBreakdown:
              'Burn Rate: ${inrFormat.format(dailyBurn)}/day • Runway Deficit: ${(daysLeft - runway).clamp(0, 30).toStringAsFixed(1)} days',
          tips: [
            'Immediate freeze on restaurant food and PayLater purchases.',
            'Review active auto-debits before the 1st of next month.',
          ],
        );
      },
    ),

    // 7. Career Delusion
    MiniCalculatorDef(
      slug: 'career-delusion',
      title: 'Career Delusion Meter',
      emoji: '🧠',
      subtitle: 'Hating your job vs doing literally nothing to leave.',
      category: 'Career',
      fields: const [
        MiniCalculatorField(
          key: 'hate_level',
          label: 'How much do you hate your job? (1 to 10)',
          type: CalculatorFieldType.slider,
          min: 1,
          max: 10,
          defaultValue: 8,
        ),
        MiniCalculatorField(
          key: 'apps_sent',
          label: 'Job applications sent in the last 30 days',
          type: CalculatorFieldType.number,
          defaultValue: 0,
        ),
        MiniCalculatorField(
          key: 'cv_months',
          label: 'Months since you last updated your CV',
          type: CalculatorFieldType.number,
          defaultValue: 14,
        ),
      ],
      compute: (inputs) {
        final hate = (inputs['hate_level'] as num?)?.toDouble() ?? 7;
        final apps = (inputs['apps_sent'] as num?)?.toDouble() ?? 0;
        final cv = (inputs['cv_months'] as num?)?.toDouble() ?? 12;

        final score = ((hate * 8) - (apps * 4) + (cv * 2)).round().clamp(0, 100);

        return MiniCalculatorResult(
          cookedScore: score,
          verdictTitle: score > 75 ? 'PROFESSIONAL COMPLAINER' : 'CAREER STRATEGIST',
          verdictEmoji: score > 75 ? '🗣️💨' : '🎯',
          verdictDescription: score > 75
              ? 'You hate your job at an 8/10 level, yet sent $apps applications. You are expecting a headhunter to parachute through your bedroom ceiling with an offer.'
              : 'You are taking proactive steps. Keep applying.',
          detailedBreakdown: 'Delusion Score: $score% • Action vs Complaint Ratio: 1 : 100',
          tips: [
            'Update your LinkedIn headline today.',
            'Send exactly 3 applications this Sunday afternoon.',
          ],
        );
      },
    ),

    // 8. Should I Buy This on EMI?
    MiniCalculatorDef(
      slug: 'should-i-buy-this-on-emi',
      title: 'Should I Buy This on EMI?',
      emoji: '💳',
      subtitle: 'The psychological trap of "No-Cost EMI" exposed.',
      category: 'Finance',
      fields: const [
        MiniCalculatorField(
          key: 'price',
          label: 'Total Product Price (₹)',
          type: CalculatorFieldType.currency,
          defaultValue: 45000,
        ),
        MiniCalculatorField(
          key: 'tenure',
          label: 'Tenure (Months)',
          type: CalculatorFieldType.slider,
          min: 3,
          max: 24,
          defaultValue: 9,
        ),
        MiniCalculatorField(
          key: 'existing_emis',
          label: 'How many EMIs are you ALREADY paying right now?',
          type: CalculatorFieldType.number,
          defaultValue: 2,
        ),
      ],
      compute: (inputs) {
        final price = (inputs['price'] as num?)?.toDouble() ?? 30000;
        final tenure = (inputs['tenure'] as num?)?.toDouble() ?? 6;
        final existing = (inputs['existing_emis'] as num?)?.toDouble() ?? 1;

        final monthly = price / tenure;
        final score = ((monthly / 500) + (existing * 20)).round().clamp(0, 100);

        return MiniCalculatorResult(
          cookedScore: score,
          verdictTitle: score > 70 ? 'EMI INDENTURED SERVITUDE' : 'MANAGEABLE INSTALLMENT',
          verdictEmoji: score > 70 ? '⛓️' : '💳',
          verdictDescription:
              'Monthly commitment: ${inrFormat.format(monthly)} for $tenure months. Stacked on top of your $existing existing EMIs, this is how people wake up poor at 35.',
          detailedBreakdown:
              'Monthly EMI: ${inrFormat.format(monthly)}/mo • Total Active EMIs: ${(existing + 1).round()}',
          tips: [
            'If you cannot afford it in cash, you cannot afford it in installments.',
            'Check processing fees and hidden GST on interest subvention.',
          ],
        );
      },
    ),

    // 9. Screen-Time Damage
    MiniCalculatorDef(
      slug: 'screen-time-damage',
      title: 'Screen-Time Damage Report',
      emoji: '📱',
      subtitle: 'Calculate what percentage of your short human life is spent scrolling.',
      category: 'Lifestyle',
      fields: const [
        MiniCalculatorField(
          key: 'hours_screen',
          label: 'Daily Screen Time (Hours)',
          type: CalculatorFieldType.slider,
          min: 2,
          max: 16,
          defaultValue: 7.5,
        ),
        MiniCalculatorField(
          key: 'wake_scroll_min',
          label: 'Minutes after waking up before you grab phone',
          type: CalculatorFieldType.number,
          defaultValue: 2,
        ),
      ],
      compute: (inputs) {
        final hours = (inputs['hours_screen'] as num?)?.toDouble() ?? 7;
        final wakeMin = (inputs['wake_scroll_min'] as num?)?.toDouble() ?? 5;

        // Assuming 16 waking hours/day
        final wakingPct = ((hours / 16) * 100).round().clamp(0, 100);
        final yearlyDays = ((hours * 365) / 24).round();
        final wakeDamage = wakeMin < 5 ? 10 : (wakeMin < 15 ? 5 : 0);

        final score = ((wakingPct * 0.95) + wakeDamage).round().clamp(0, 100);

        return MiniCalculatorResult(
          cookedScore: score,
          verdictTitle: score > 60 ? 'TERMINALLY ONLINE CYBORG' : 'BALANCED HUMAN',
          verdictEmoji: score > 60 ? '🤖🧠' : '🌿',
          verdictDescription:
              'You spend $wakingPct% of your conscious waking existence staring at glass. That is $yearlyDays FULL DAYS of pure scrolling every year.',
          detailedBreakdown:
              'Waking Life on Screen: $wakingPct% • Annual Days Lost: $yearlyDays days',
          tips: [
            'Set grayscale color mode on your phone screen to kill dopamine.',
            'Do not touch your phone for the first 30 minutes of the morning.',
          ],
        );
      },
    ),

    // 10. Are They Ghosting Me?
    MiniCalculatorDef(
      slug: 'are-they-ghosting-me',
      title: 'Are They Ghosting Me?',
      emoji: '❤️',
      subtitle: 'Statistical probability that they didn’t "just fall asleep".',
      category: 'Lifestyle',
      fields: const [
        MiniCalculatorField(
          key: 'hours_since_text',
          label: 'Hours since you sent the last message',
          type: CalculatorFieldType.number,
          defaultValue: 18,
        ),
        MiniCalculatorField(
          key: 'status',
          label: 'Their Activity Status',
          type: CalculatorFieldType.dropdown,
          defaultString: 'posted_story',
          dropdownOptions: [
            DropdownOption(label: 'Posted an Instagram story 20 mins ago', value: 'posted_story'),
            DropdownOption(label: 'Last seen on WhatsApp is updating', value: 'whatsapp_active'),
            DropdownOption(label: 'Completely offline everywhere', value: 'offline'),
          ],
        ),
      ],
      compute: (inputs) {
        final hours = (inputs['hours_since_text'] as num?)?.toDouble() ?? 12;
        final status = inputs['status'] as String? ?? 'posted_story';

        int score = 40;
        if (hours > 6) score += 20;
        if (hours > 24) score += 30;
        if (status == 'posted_story') score += 25;
        if (status == 'whatsapp_active') score += 20;

        score = score.clamp(0, 100);

        return MiniCalculatorResult(
          cookedScore: score,
          verdictTitle: score > 75 ? 'CERTIFIED GHOST TOWN 👻' : 'GIVE IT A MINUTE',
          verdictEmoji: score > 75 ? '🪦' : '⏳',
          verdictDescription: score > 75
              ? 'They have posted a story, liked 3 memes, and been online 4 times. Their phone is literally glued to their hand. You have your answer, king.'
              : 'Still within standard response variance. Do NOT double text.',
          detailedBreakdown: 'Ghost Probability: $score% • Recommended Action: Put the phone down',
          tips: [
            'Never send the "guess you are busy" passive aggressive follow-up.',
            'Mute the chat and go to the gym.',
          ],
        );
      },
    ),
  ];

  static MiniCalculatorDef? getBySlug(String slug) {
    return all.cast<MiniCalculatorDef?>().firstWhere(
          (c) => c?.slug == slug,
          orElse: () => null,
        );
  }
}
