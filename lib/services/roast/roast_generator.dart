import '../scoring/cooked_models.dart';

class RoastGenerator {
  /// Generates a hilarious, deterministic, playful roast based on specific answers and category breakdown.
  static String generateRoast({
    required int score,
    required CategoryScores categoryScores,
    required List<String> roastTags,
    required Map<String, String> answers,
  }) {
    if (score <= 20) {
      return "You sleep 8 hours, have an emergency fund, and drink 3 liters of water. Honestly? Who invited you? We built this app for degenerates, not for someone with a diversified index fund portfolio and clear skin. Go back to LinkedIn, you menace. 🥩";
    }

    if (score <= 40) {
      return "You're only lightly toasted. You occasionally order late-night fries and buy a book you'll never read, but you still pay rent on time and your parents aren't actively crying about your future. Clean your room, drink a glass of water, and you might actually survive the decade. 🍞";
    }

    // High finance damage
    final isFinanceDisaster = categoryScores.finance >= 75 ||
        roastTags.contains('balance_coward') ||
        roastTags.contains('financial_fugitive') ||
        roastTags.contains('eighteen_days_poor') ||
        roastTags.contains('instant_broke');

    final isSleepZombie = categoryScores.sleep >= 75 ||
        roastTags.contains('insomnia_corpse') ||
        roastTags.contains('caffeine_zombie') ||
        roastTags.contains('face_drop_phone');

    final isScreenRot = categoryScores.spending >= 75 ||
        roastTags.contains('screen_time_censored') ||
        roastTags.contains('cyborg_scroller');

    final isCareerApathy = categoryScores.career >= 75 ||
        roastTags.contains('medical_excuse_inventor') ||
        roastTags.contains('himalayan_monk_dreamer');

    if (score >= 96) {
      return "CALL 911 RIGHT NOW. 🚒🔥\n\n"
          "Your bank account has the pulse of a Victorian ghost, your sleep schedule was dictated by an offshore night-shift owl, and you just considered putting a ₹3,000 dinner on a 6-month EMI.\n\n"
          "Brother. You aren't just cooked. You are carbonized ash. Even the IRS has given up on auditing you out of sheer pity. 💀";
    }

    if (isFinanceDisaster && isSleepZombie) {
      return "You have ₹1,847 left in your checking account, 18 days until payday, two overdue credit card alerts, and you're lying in bed at 3:14 AM watching TikToks on how to make passive income from goat farming.\n\n"
          "Brother.\n\n"
          "You are not financially planning.\n"
          "You are speedrunning bankruptcy while hallucinating from lack of REM sleep. 💀";
    }

    if (isFinanceDisaster) {
      return "You checked your bank balance, felt physical pain in your chest, immediately closed the app, and then ordered iced coffee to soothe the trauma.\n\n"
          "Your credit card limit is not free money, your EMI isn't an investment, and no, Swiggy Gold does not count as grocery shopping. 💀";
    }

    if (isSleepZombie && isScreenRot) {
      return "Your screen time is higher than your waking hours, which defies both biology and Euclidean geometry. You drop your phone on your bridge of nose at 2:00 AM, blink, and it's suddenly Tuesday.\n\n"
          "Your dark circles have their own pin code. Put the phone in the freezer and go to sleep. 🦉";
    }

    if (isCareerApathy) {
      return "You stare at your ceiling every morning at 7:30 AM calculating whether stubbing your toe hard enough justifies three days of medical leave.\n\n"
          "Your five-year plan is 'surviving until Friday 6 PM', and your resume is an unsaved Word document from 2018. The corporate machine is winning, king. 💻";
    }

    // Default pretty cooked / absolutely cooked roasts
    if (score >= 81) {
      return "You are absolute charcoal right now. 87% cooked to a crisp.\n\n"
          "You survive on vibes, iced caffeine, and the misplaced hope that next month will be different without changing a single habit. It won't be. You need an adult, and unfortunately, you are supposed to be that adult. 💀";
    }

    return "You are comfortably simmering at $score%. Not quite burned to a crisp yet, but if your boss messages you this weekend or your car makes a weird clicking sound, the entire fragile illusion will collapse like a cheap folding chair. 🌡️";
  }

  /// Generates 3-5 personalized emergency plan recommendations
  static List<String> generateEmergencyPlan({
    required int score,
    required CategoryScores categoryScores,
    required List<String> roastTags,
  }) {
    final list = <String>[];

    if (score <= 20) {
      return [
        "1. Teach a masterclass on how to have your life together.",
        "2. Keep drinking 2 liters of water daily.",
        "3. Stay humble, you annoying overachiever.",
      ];
    }

    // Finance advice
    if (categoryScores.finance >= 50 || roastTags.contains('balance_coward')) {
      list.add("Stop opening Amazon & Zomato when you're bored. Drink tap water.");
      list.add("Do not take another 'No-Cost EMI' for anything with a battery.");
    }

    // Sleep advice
    if (categoryScores.sleep >= 50 || roastTags.contains('face_drop_phone')) {
      list.add("Put your phone across the room before 11:30 PM. TikTok won't miss you.");
      list.add("Sleep before 2:00 AM. Sleep is not a subscription you can cancel.");
    }

    // Screen time advice
    if (categoryScores.spending >= 50) {
      list.add("Touch grass for at least 12 uninterrupted minutes today.");
    }

    // Career advice
    if (categoryScores.career >= 50) {
      list.add("Open that dusty resume doc, fix the formatting, and send 2 applications.");
      list.add("Mute the work Slack channel after 7:00 PM without feeling guilty.");
    }

    // General fallback items to make sure there are always 3-5 items
    if (list.length < 3) {
      list.add("Drink one large glass of water right now.");
      list.add("Reply to that one friend you ghosted 3 weeks ago.");
      list.add("Take a deep breath and accept that everyone else is winging it too.");
    }

    return list.take(5).toList();
  }
}
