--ヴァリアンツM－マーキス
--
--Script by Trishula9
function c100418207.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,100418207)
	e1:SetCondition(c100418207.spcon)
	e1:SetTarget(c100418207.sptg)
	e1:SetOperation(c100418207.spop)
	c:RegisterEffect(e1)
	--dice
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DICE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100418207+100)
	e2:SetTarget(c100418207.dctg)
	e2:SetOperation(c100418207.dcop)
	c:RegisterEffect(e2)
	--dice
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DICE+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_MOVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,100418207+200)
	e3:SetCondition(c100418207.mvcon)
	e3:SetTarget(c100418207.mvtg)
	e3:SetOperation(c100418207.mvop)
	c:RegisterEffect(e3)
end
function c100418207.cfilter(c)
	return c:IsSetCard(0x27c) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsFaceup()
end
function c100418207.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(100418212) or Duel.IsExistingMatchingCard(c100418207.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100418207.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local zone=1<<c:GetSequence()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c100418207.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=1<<c:GetSequence()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
function c100418207.dctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c100418207.thfilter(c)
	return c:IsSetCard(0x27c) and c:IsAbleToHand()
end
function c100418207.dcop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	local dc=Duel.TossDice(tp,1)
	Duel.ConfirmDecktop(tp,dc)
	local dg=Duel.GetDecktopGroup(tp,dc)
	local g=dg:Filter(c100418207.thfilter,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(100418207,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
	Duel.ShuffleDeck(tp)
end
function c100418207.mvcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsLocation(LOCATION_MZONE)
		and (c:GetPreviousSequence()~=c:GetSequence() or c:GetPreviousControler()~=tp)
end
function c100418207.spfilter(c,e,tp)
	local zone=1<<c:GetSequence()
	return c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c100418207.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c100418207.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_SZONE)
end
function c100418207.mvop(e,tp,eg,ep,ev,re,r,rp)
	local dc=Duel.TossDice(tp,1)
	if dc<2 or dc>5 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100418207.spfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,1<<tc:GetSequence())
	end
end