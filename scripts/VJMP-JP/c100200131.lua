--プロキシー・ドラゴン
--Proxy Dragon
--Script by nekrozar
function c100200131.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2)
	c:EnableReviveLimit()
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c100200131.desreptg)
	e1:SetValue(c100200131.desrepval)
	e1:SetOperation(c100200131.desrepop)
	c:RegisterEffect(e1)
end
function c100200131.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c100200131.desfilter(c,tp)
	return c:IsControler(tp) and c:IsType(TYPE_MONSTER)
		and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function c100200131.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetLinkedGroup()
	if chk==0 then return eg:IsExists(c100200131.repfilter,1,nil,tp)
		and g:IsExists(c100200131.desfilter,1,nil,tp) end
	if Duel.SelectYesNo(tp,aux.Stringid(100200131,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local sg=g:FilterSelect(tp,c100200131.desfilter,1,1,nil,tp)
		e:SetLabelObject(sg:GetFirst())
		Duel.HintSelection(sg)
		sg:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function c100200131.desrepval(e,c)
	return c100200131.repfilter(c,e:GetHandlerPlayer())
end
function c100200131.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end
