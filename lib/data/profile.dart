class Profile {
  static const name = 'Arun Prakash';
  static const role = 'Data Engineer II';
  static const company = 'Amdocs';
  static const city = 'Pune';
  static const email = 'arunedappal5@gmail.com';
  static const phoneDisplay = '+91 97465 57554';
  static const phoneUri = 'tel:+919746557554';
  static const mailUri = 'mailto:arunedappal5@gmail.com';
  static const github = 'https://github.com/Arun-Prakash-Dev';
  static const databricksCredential =
      'https://credentials.databricks.com/2510441a-fdea-4fb6-bcb1-fac30de9555c';

  static const socials = <SocialLink>[
    SocialLink('GitHub', github),
    SocialLink('Instagram', 'https://www.instagram.com/_.arun._.prakash._/'),
    SocialLink('Facebook', 'https://www.facebook.com/arun.edappal.35/'),
    SocialLink('X', 'https://twitter.com/ARUNPRA52454514'),
    SocialLink('YouTube', 'https://www.youtube.com/@theartist317'),
  ];

  static const stats = <Stat>[
    Stat('3+', 'Years building data platforms'),
    Stat('Amdocs', 'Data Engineer II, Pune'),
    Stat('Lakehouse', 'Databricks, DLT, Unity Catalog'),
    Stat('Professional', 'Databricks Certified Data Engineer'),
  ];

  static const stages = <Stage>[
    Stage('01', 'Ingest', 'Billing, CRM, and event sources'),
    Stage('02', 'Bronze', 'Raw tables, append-only'),
    Stage('03', 'Silver', 'Cleaned data and quality checks'),
    Stage('04', 'Gold', 'Models ready for analytics'),
  ];

  static const work = <WorkItem>[
    WorkItem(
      index: '01',
      title: 'Enterprise data architecture',
      summary:
          'I design and maintain pipelines on Azure Databricks and Snowflake so analytics across the business has a platform it can rely on.',
      outcome: 'A lakehouse shaped for scale, not a pile of one-off jobs.',
      tags: ['Azure Databricks', 'Snowflake', 'Lakehouse'],
    ),
    WorkItem(
      index: '02',
      title: 'Batch and streaming, automated',
      summary:
          'Delta Live Tables runs both scheduled batches and real-time streams, with checks that stop bad records from moving downstream.',
      outcome: 'Pipelines that recover less often and can be trusted more.',
      tags: ['Delta Live Tables', 'PySpark', 'Data quality'],
    ),
    WorkItem(
      index: '03',
      title: 'Governance in Unity Catalog',
      summary:
          'Access, metadata, and ownership sit in Unity Catalog, so permissions are fine-grained and visible in one place.',
      outcome: 'Governance that travels with the table.',
      tags: ['Unity Catalog', 'Access control', 'Metadata'],
    ),
    WorkItem(
      index: '04',
      title: 'Spark cost and performance',
      summary:
          'I read Spark UI, find the shuffle, and change the job. The same result should not need the same amount of compute.',
      outcome: 'Faster runs and a smaller compute bill.',
      tags: ['Spark UI', 'Shuffle', 'Cost'],
    ),
  ];

  static const focus = <String>[
    'Architect and sustain scalable pipelines on Azure Databricks and Snowflake.',
    'Orchestrate batch and streaming with Delta Live Tables, and protect data integrity along the way.',
    'Enforce access control and metadata standards through Unity Catalog.',
    'Tune Spark workloads by removing shuffle bottlenecks and cutting wasted compute.',
    'Mentor junior engineers and turn datasets into something stakeholders can act on.',
  ];

  static const skillGroups = <SkillGroup>[
    SkillGroup('Languages', ['Python', 'SQL', 'PySpark']),
    SkillGroup('Platforms', [
      'Azure Databricks',
      'Snowflake',
      'Delta Live Tables',
      'Unity Catalog',
      'Delta Lake',
    ]),
    SkillGroup('Practice', [
      'Pipeline architecture',
      'Lakehouse design',
      'Data governance',
      'Performance tuning',
      'Data quality',
      'Data migration',
      'Business intelligence',
    ]),
  ];

  static const projects = <SideProject>[
    SideProject(
      'WhatsApp UI clone',
      'A Flutter recreation of the WhatsApp interface.',
      'https://github.com/Arun-Prakash-Dev/WhatsApp-UI-Clone--Flutter',
    ),
    SideProject(
      'Cowin Slot Finder',
      'An app on the CoWIN API for finding vaccination slots in India.',
      'https://github.com/Arun-Prakash-Dev/Cowin-Slot-Finder-App',
    ),
    SideProject(
      'Wallpaper Hub',
      'Download and set home and lock-screen wallpapers from the Pixabay API.',
      'https://github.com/Arun-Prakash-Dev/WALLPAPER_HUB',
    ),
    SideProject(
      'Black Hole animation',
      'A small Flutter tween study: a box falls in, and the minus button brings it back.',
      'https://github.com/Arun-Prakash-Dev/Black-Hole-animation',
    ),
  ];
}

class SocialLink {
  final String label;
  final String url;
  const SocialLink(this.label, this.url);
}

class Stat {
  final String value;
  final String label;
  const Stat(this.value, this.label);
}

class Stage {
  final String index;
  final String title;
  final String detail;
  const Stage(this.index, this.title, this.detail);
}

class WorkItem {
  final String index;
  final String title;
  final String summary;
  final String outcome;
  final List<String> tags;
  const WorkItem({
    required this.index,
    required this.title,
    required this.summary,
    required this.outcome,
    required this.tags,
  });
}

class SkillGroup {
  final String title;
  final List<String> items;
  const SkillGroup(this.title, this.items);
}

class SideProject {
  final String title;
  final String summary;
  final String url;
  const SideProject(this.title, this.summary, this.url);
}
