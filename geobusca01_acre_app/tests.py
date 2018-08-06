import datetime

from django.utils import timezone
from django.test import TestCase
from django.urls import reverse
from django.contrib.gis.geos import GEOSGeometry, LineString, Point

from .models import Raster, Ponto, Chave, Etiqueta

class QuestionModelTests(TestCase):

    def test_periodo_positivo_com_tempo_negativo(self):
        """
        Não pode ser possível uma data mínima maior que a data máxima
        pois isso levaria a um período negativo de busca.
        """
        min_date = timezone.now()
        max_date = timezone.now() - datetime.timedelta(days=-30)
        periodo_negativo = Ponto(req_min_date=min_date, req_max_date=max_date)
        self.assertIs(periodo_negativo.periodo_positivo(), False)


def create_point(ponto_point, ponto_query_date, days, ponto_chaves):
    """
    Cria um ponto com um dado `ponto_point`, um dado período de tempo e
    uma quantidade de `ponto_chaves`.  O período é negativo se o valor de
    `days` for negativo.
    """
    Etiqueta.objects.create(nome='etiqueta_teste')
    Chave.objects.create(nome='chave_teste')
    etiqueta_para_chaves = Etiqueta.objects.all()
    chave_teste.etiquetas.set(etiqueta_para_chaves)
    chave_teste.save()
    min_date = timezone.now() - datetime.timedelta(days=days)
    max_date = timezone.now() + datetime.timedelta(days=days)
    return Ponto.objects.create(point=ponto_point, query_date=ponto_query_date, req_min_date=min_date, req_max_date=max_date, ponto_chaves=chaves)

class PontoIndexViewTests(TestCase):
    def test_no_points(self):
        """
        Se nenhum ponto existir, uma mensagem apropriada será exibida.
        """
        response = self.client.get(reverse('geobusca01_acre_app:index'))
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, "Nenhum ponto disponível")
        self.assertQuerysetEqual(response.context['latest_ponto_list'], [])


class QuestionBuscaViewTests(TestCase):
    def test_negative_range(self):
        """
        Se for colocada uma data mínima maior que a data máxima,
        uma mensagem apropriada será exibida.
        """
        chaves_para_ponto = Chave.objects.all()
        ponto_chaves.set(chaves_para_ponto)
        periodo_negativo = create_point(ponto_point=GEOSGeometry('POINT (0 0)', srid=4326), ponto_query_date=timezone.now(), days=-5, ponto_chaves=ponto_chaves)
        url = reverse('polls:busca', args=(periodo_negativo.id,))
        response = self.client.get(url)
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, "A data máxima não pode ser menor que a data mínima.")
        
#
#    def test_past_question(self):
#        """
#        The detail view of a question with a pub_date in the past
#        displays the question's text.
#        """
#        past_question = create_question(question_text='Past Question.', days=-5)
#        url = reverse('polls:detail', args=(past_question.id,))
#        response = self.client.get(url)
#        self.assertContains(response, past_question.question_text)
#
