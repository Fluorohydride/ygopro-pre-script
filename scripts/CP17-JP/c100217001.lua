--オッドアイズ・ランサー・ドラゴン
--Odd-Eyes Lancer Dragon
--Scripted by Eerie Code
function c100217001.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100217001,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c100217001.spcon)
	e1:SetCost(c100217001.spcost)
	e1:SetTarget(c100217001.sptg)
	e1:SetOperation(c100217001.spop)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c100217001.aclimit)
	e2:SetCondition(c100217001.actcon)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c100217001.reptg)
	e3:SetValue(c100217001.repval)
	e3:SetOperation(c100217001.repop)
	c:RegisterEffect(e3)
end
function c100217001.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsType(TYPE_PENDULUM)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c100217001.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100217001.cfilter,1,nil,tp)
end
function c100217001.rfilter(c,ft,tp)
	return (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
end
function c100217001.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,c100217001.rfilter,1,nil,ft,tp) end
	local sg=Duel.SelectReleaseGroup(tp,c100217001.rfilter,1,1,nil,ft,tp)
	Duel.Release(sg,REASON_COST)
end
function c100217001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c100217001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100217001.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c100217001.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
function c100217001.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0x99)
		and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT)) and not c:IsReason(REASON_REPLACE)
end
function c100217001.desfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_HAND+LOCATION_MZONE+LOCATION_PZONE) and c:IsSetCard(0x99)
		and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function c100217001.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c100217001.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(c100217001.desfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_PZONE,0,1,nil,tp) end
	if Duel.SelectYesNo(tp,aux.Stringid(100217001,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c100217001.desfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_PZONE,0,1,1,nil,tp)
		e:SetLabelObject(g:GetFirst())
		Duel.HintSelection(g)
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	end
	return false
end
function c100217001.repval(e,c)
	return c100217001.repfilter(c,e:GetHandlerPlayer())
end
function c100217001.repop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end
