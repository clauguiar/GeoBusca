# Generated by Django 2.0.4 on 2018-05-14 20:42

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('geobusca01_acre_app', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='raster',
            name='src_srs',
            field=models.CharField(max_length=254, null=True, verbose_name='EPSG original'),
        ),
    ]