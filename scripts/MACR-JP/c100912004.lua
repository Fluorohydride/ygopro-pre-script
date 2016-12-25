--EMユーゴーレム
--Performapal Fugolem
--Scripted by Eerie Code
function c100912004.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--salvage
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1)
	e1:SetCondition(c100912004.thcon)
	e1:SetTarget(c100912004.thtg)
	e1:SetOperation(c100912004.thop)
	c:RegisterEffect(e1)
	--reg
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(c100912004.effcon)
	e2:SetOperation(c100912004.regop)
	c:RegisterEffect(e2)
	--fusion
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c100912004.spcon)
	e3:SetTarget(c100912004.sptg)
	e3:SetOperation(c100912004.spop)
	c:RegisterEffect(e3)
end
function c100912004.thcfilter(c,tp)
	return c:IsControler(tp) and bit.band(c:GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c100912004.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c100912004.thcfilter,1,nil,tp)
end
function c100912004.thfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x98) or c:IsSetCard(0x99) or c:IsSetCard(0x9f))
		and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c100912004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c100912004.thfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c100912004.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100912004.thfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	if tc:IsHasEffect(EFFECT_NECRO_VALLEY) and Duel.IsChainDisablable(0) then
		Duel.NegateEffect(0)
		return
	end
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
end
function c100912004.effcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c100912004.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(100912004,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c100912004.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(100912004)~=0
end
function c100912004.spfilter0(c)
	return c:IsRace(RACE_DRAGON) and c:IsCanBeFusionMaterial()
end
function c100912004.spfilter1(c,e)
	return c100912004.spfilter0(c) and not c:IsImmuneToEffect(e)
end
function c100912004.spfilter2(c,e,tp,m,f,gc)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,gc)
end
function c100912004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local mg1=Duel.GetMatchingGroup(c100912004.spfilter0,tp,LOCATION_MZONE,0,c)
		local res=Duel.IsExistingMatchingCard(c100912004.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,c)
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c100912004.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end
	local mg1=Duel.GetMatchingGroup(c100912004.spfilter1,tp,LOCATION_MZONE,0,c,e)
	local sg1=Duel.GetMatchingGroup(c100912004.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,c)
	if sg1:GetCount()>0 then
		local sg=sg1:Clone()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,c)
		tc:SetMaterial(mat1)
		Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
