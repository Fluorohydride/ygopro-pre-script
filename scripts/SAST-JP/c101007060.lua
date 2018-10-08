--ネオス・フュージョン
--Neos Fusion
--Script by mercury233
function c101007060.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101007060,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101007060.target)
	e1:SetOperation(c101007060.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c101007060.reptg)
	e2:SetValue(c101007060.repval)
	e2:SetOperation(c101007060.repop)
	c:RegisterEffect(e2)
	--return replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101007060,1))
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(101007060)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c101007060.repcon2)
	e3:SetOperation(c101007060.repop2)
	c:RegisterEffect(e3)
end
c101007060.card_code_list={89943723}
function c101007060.filter1(c,e)
	return c:IsAbleToGrave() and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c101007060.filter2(c,e,tp,m,chkf)
	return c.neos_fusion and aux.IsMaterialListCode(c,89943723)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c101007060.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg=Duel.GetMatchingGroup(c101007060.filter1,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK,0,nil,e)
		return Duel.IsExistingMatchingCard(c101007060.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,chkf)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101007060.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg=Duel.GetMatchingGroup(c101007060.filter1,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK,0,nil,e)
	local sg=Duel.GetMatchingGroup(c101007060.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,chkf)
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		local mat=Duel.SelectFusionMaterial(tp,tc,mg,nil,chkf)
		Duel.SendtoGrave(mat,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTargetRange(1,0)
		Duel.RegisterEffect(e1,tp)
	end
end
function c101007060.repfilter(c,tp)
	return c:IsFaceup() and aux.IsMaterialListCode(c,89943723) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c101007060.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c101007060.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c101007060.repval(e,c)
	return c101007060.repfilter(c,e:GetHandlerPlayer())
end
function c101007060.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
function c101007060.repcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAbleToRemove()
end
function c101007060.repop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
