--二重露光

--Script by Chrono-Genex
function c100278040.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--lv
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100278040,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,100278040)
	e2:SetTarget(c100278040.lvtg)
	e2:SetOperation(c100278040.lvop)
	c:RegisterEffect(e2)
	--name
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100278040,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,100278140)
	e3:SetTarget(c100278040.nametg)
	e3:SetOperation(c100278040.nameop)
	c:RegisterEffect(e3)
end
function c100278040.lvfilter(c,e)
	return c:IsFaceup() and c:IsLevelBelow(6) and c:IsCanBeEffectTarget(e)
end
function c100278040.fselect(g)
	return g:GetClassCount(Card.GetCode)==1
end
function c100278040.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c100278040.lvfilter,tp,LOCATION_MZONE,0,nil,e)
	if chkc then return false end
	if chk==0 then return g:CheckSubGroup(c100278040.fselect,2,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local sg=g:SelectSubGroup(tp,c100278040.fselect,false,2,2)
	Duel.SetTargetCard(sg)
end
function c100278040.tgfilter(c,e)
	return c:IsFaceup() and c:IsRelateToEffect(e)
end
function c100278040.lvop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c100278040.tgfilter,nil,e)
	if g:GetCount()<=0 then return end
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(tc:GetLevel()*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c100278040.namefilter(c,code)
	return c:IsFaceup() and not c:IsCode(code)
end
function c100278040.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe5)
		and Duel.IsExistingMatchingCard(c100278040.namefilter,0,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetCode())
end
function c100278040.nametg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100278040.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100278040.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(100278040,2))
	Duel.SelectTarget(tp,c100278040.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c100278040.nameop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local code=tc:GetCode()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(100278040,3))
		local g=Duel.SelectMatchingCard(tp,c100278040.namefilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,tc,code)
		local sc=g:GetFirst()
		if sc then
			Duel.HintSelection(g)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetValue(tc:GetCode())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			sc:RegisterEffect(e1)
		end
	end
end
