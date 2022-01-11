--音響戦士ディージェス
--
--Script by Trishula9
function c101108021.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pos change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101108021,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c101108021.postg)
	e1:SetOperation(c101108021.posop)
	c:RegisterEffect(e1)
	--pzone spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101108021,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,101108021)
	e2:SetCondition(c101108021.pspcon)
	e2:SetTarget(c101108021.psptg)
	e2:SetOperation(c101108021.pspop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101108021,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,101108021+100)
	e3:SetTarget(c101108021.sptg)
	e3:SetOperation(c101108021.spop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c101108021.posfilter(c)
	return c:IsSetCard(0x1066) and c:IsFacedown()
end
function c101108021.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101108021.posfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,tp,LOCATION_MZONE)
end
function c101108021.posop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local tc=Duel.SelectMatchingCard(tp,c101108021.posfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if tc then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
	end
end
function c101108021.pspcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x1066)
end
function c101108021.psptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101108021.pspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101108021.spfilter1(c,e,tp)
	return c:IsSetCard(0x1066) and not c:IsCode(101108021) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c101108021.spfilter2(c,e,tp)
	return c:IsSetCard(0x1066) and not c:IsCode(101108021) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101108021.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b=Duel.IsEnvironment(75304793,tp,LOCATION_FZONE)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101108021.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp)
		or b and Duel.IsExistingMatchingCard(c101108021.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101108021.spop(e,tp,eg,ep,ev,re,r,rp)
	local b=Duel.IsEnvironment(75304793,tp,LOCATION_FZONE)
	if b and Duel.IsExistingMatchingCard(c101108021.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp)
		and (not Duel.IsExistingMatchingCard(c101108021.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp)
			or Duel.SelectYesNo(tp,aux.Stringid(101108021,3))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c101108021.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			Duel.SpecialSummonComplete()
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c101108021.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
