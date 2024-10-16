# Generated by Django 5.1.2 on 2024-10-14 12:28

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("accounts", "0003_chamamembership"),
    ]

    operations = [
        migrations.AddField(
            model_name="chamamembership",
            name="is_admin",
            field=models.BooleanField(default=False),
        ),
        migrations.AlterField(
            model_name="customuser",
            name="user_role",
            field=models.CharField(
                choices=[("chamaMember", "Chama Member"), ("appAdmin", "App Admin")],
                default="chamaMember",
                max_length=20,
            ),
        ),
    ]
