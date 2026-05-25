-- 043: Crear cuentas de acceso para todas las alumnas importadas
-- Ejecutar DESPUÉS de la migration 042.
-- Usa net.http_post para llamar a setup-alumna-auth por cada alumna.

DO $$
DECLARE
  v_edge   text := 'https://dplzkrdgnynyyunmrawr.supabase.co/functions/v1/setup-alumna-auth';
  v_key    text := 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRwbHprcmRnbnlueXl1bm1yYXdyIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3OTAyODY5MywiZXhwIjoyMDk0NjA0NjkzfQ.hyH2MoS8GNPzD3_SuU_dlGAG_taekEhtm4HtElR2ugA';
  v_aid    integer;
  v_pass   text;
BEGIN

  -- Uma Gomez
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='50415207'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','50415207@triskel.local','password','170710')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Anita Cerrato
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='44241485'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','44241485@triskel.local','password','240203')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Luciana Perez
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='29292122'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','29292122@triskel.local','password','040382')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Isabel Da Luz Fernandez
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='11917553'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','11917553@triskel.local','password','280355')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Lara Bolea
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='42323024'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','42323024@triskel.local','password','170600')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Flavia Giselle Becker
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='28862311'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','28862311@triskel.local','password','090581')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Maria Villavicencio
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='24824149'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','24824149@triskel.local','password','180975')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Gabriela Perez
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='24819252'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','24819252@triskel.local','password','090875')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Stephanie Pintos Pelayo
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='93939434'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','93939434@triskel.local','password','311087')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Magali Avril Pighetti Becker
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='51509591'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','51509591@triskel.local','password','231111')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Catalina Ezcurra
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='49959524'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','49959524@triskel.local','password','141209')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Paula Velasco
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='40425555'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','40425555@triskel.local','password','260198')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Julieta Cornador
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='39353563'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','39353563@triskel.local','password','051295')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Lucia Cesar
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='38960016'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','38960016@triskel.local','password','270396')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Karen Juarez
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='38948989'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','38948989@triskel.local','password','021295')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Julieta Larrosa
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='38150986'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','38150986@triskel.local','password','100594')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Micaela Aguilar
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='36542717'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','36542717@triskel.local','password','140692')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Silvina Canosa Sanchez
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='33027872'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','33027872@triskel.local','password','180487')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Sol Penín
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='31646680'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','31646680@triskel.local','password','020285')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Soledad Garavano
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='31415455'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','31415455@triskel.local','password','250185')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Natalia Baldomero
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='28867235'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','28867235@triskel.local','password','220781')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Gabriela Billordo
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='28098760'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','28098760@triskel.local','password','030580')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Ximena Luque
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='27089514'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','27089514@triskel.local','password','151278')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Priscila Sanz
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='26589330'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','26589330@triskel.local','password','010579')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Lidia Bianciotto
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='26168614'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','26168614@triskel.local','password','311077')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Paola Bilello
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='26044345'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','26044345@triskel.local','password','200677')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Martha Alberto
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='24844729'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','24844729@triskel.local','password','060376')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Stella Maris Samorano
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='23830977'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','23830977@triskel.local','password','130874')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Marcela Rasquetti
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='23568659'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','23568659@triskel.local','password','130274')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Claudia Soriano
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='22696426'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','22696426@triskel.local','password','090472')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Mónica Coronel
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='20555211'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','20555211@triskel.local','password','150269')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Veronica Iraola
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='20446005'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','20446005@triskel.local','password','220768')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Analia Marcela Menakian
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='18478185'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','18478185@triskel.local','password','071267')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Mirta Amarilla
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='18248516'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','18248516@triskel.local','password','251065')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Fernanda Perez Armari
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='17907070'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','17907070@triskel.local','password','030566')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Silvia Laura Velazquez
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='16910396'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','16910396@triskel.local','password','300664')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Claudia Iraola
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='16910135'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','16910135@triskel.local','password','180165')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Sandra Zampone
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='16527529'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','16527529@triskel.local','password','081063')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Maria Andrea Bottero
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='16527522'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','16527522@triskel.local','password','171161')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Adriana Iraola
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='16004904'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','16004904@triskel.local','password','260162')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Irma Rosa Vilas
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='10796800'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','10796800@triskel.local','password','190644')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

  -- Maria Cristina Garegnani
  SELECT id INTO v_aid FROM triskel_alumnas WHERE dni='10091573'
  LIMIT 1;
  IF v_aid IS NOT NULL THEN
    PERFORM net.http_post(
      url     := v_edge,
      headers := jsonb_build_object('Content-Type','application/json','Authorization','Bearer '||v_key),
      body    := jsonb_build_object('alumna_id',v_aid,'email','10091573@triskel.local','password','191151')
    );
  END IF;
  PERFORM pg_sleep(0.3); -- evitar rate limit

END $$;