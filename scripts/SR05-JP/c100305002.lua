--天空賢者ミネルヴァ
--Angel Sage Minerva
--Scripted by Eerie Code
function c100305002.initial_effect(c)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(aux.chainreg)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100305002,0))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c100305002.atkcon)
	e4:SetOperation(c100305002.atkop)
	c:RegisterEffect(e4)
end
function c100305002.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsType(TYPE_COUNTER) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetHandler():GetFlagEffect(1)>0
end
function c100305002.thfilter(c,cc)
	return c:IsType(TYPE_COUNTER) and not c:IsCode(cc) and c:IsAbleToHand()
end
function c100305002.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_CARD,PLAYER_ALL,100305002)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
	local rc=re:GetHandler()
	if not rc then return end
	local cc=rc:GetCode()
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c100305002.thfilter),tp,LOCATION_GRAVE,0,nil,cc)
	if Duel.IsEnvironment(56433456) and g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end